import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_io2_examen/domain/entities/estudiante.dart';
import 'package:app_io2_examen/domain/repositories/estudiante_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class EstudianteRepositoryImpl implements EstudianteRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  EstudianteRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _usuariosRef => _firestore.collection('usuarios');

  @override
  Future<void> agregarEstudiante(Estudiante estudiante, String docenteId) async {
    await _usuariosRef.doc(estudiante.email).set({
      ...estudiante.toMap(),
      'docenteId': docenteId,
      'activo': true,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> actualizarEstudiante(Estudiante estudiante) async {
    await _usuariosRef.doc(estudiante.email).update(estudiante.toMap());
  }

  @override
  Future<void> actualizarEstado(String email, bool activo) async {
    await _usuariosRef.doc(email).update({'activo': activo});
  }

  @override
  Future<void> eliminarEstudiante(String email) async {
    await _usuariosRef.doc(email).delete();
  }

  @override
  Future<void> eliminarTodosEstudiantes(String docenteId) async {
    final batch = _firestore.batch();
    final estudiantes = await _usuariosRef
        .where('docenteId', isEqualTo: docenteId)
        .get();

    for (final doc in estudiantes.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  @override
  Stream<List<Estudiante>> obtenerEstudiantesPorDocente(String docenteId) {
    try {
      return _usuariosRef
          .where('docenteId', isEqualTo: docenteId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .handleError((error) {
        debugPrint('Error al obtener estudiantes: $error');
        return Stream.value([]); // Retorna lista vacía en caso de error
      })
          .map((snapshot) => snapshot.docs
          .map((doc) {
        try {
          return Estudiante.fromFirestore(doc.data() as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Error al parsear estudiante: $e');
          return Estudiante(
            nombre: 'Error',
            carrera: '',
            telefono: '',
            email: doc.id,
            activo: false,
          );
        }
      })
          .where((estudiante) => estudiante.nombre != 'Error') // Filtra los errores
          .toList());
    } catch (e) {
      debugPrint('Error en obtenerEstudiantesPorDocente: $e');
      return Stream.value([]);
    }
  }

  @override
  Future<int> importarEstudiantes(
      List<Estudiante> estudiantes,
      String docenteId,
      ) async {
    final batch = _firestore.batch();
    int contador = 0;

    // Obtener emails existentes en una sola consulta
    final existingEmails = await _usuariosRef
        .where(FieldPath.documentId, whereIn: estudiantes.map((e) => e.email).toList())
        .get()
        .then((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());

    for (final estudiante in estudiantes) {
      if (!existingEmails.contains(estudiante.email)) {
        batch.set(_usuariosRef.doc(estudiante.email), {
          ...estudiante.toMap(),
          'docenteId': docenteId,
          'activo': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        contador++;
      }
    }

    if (contador > 0) {
      await batch.commit();
    }
    return contador;
  }
}
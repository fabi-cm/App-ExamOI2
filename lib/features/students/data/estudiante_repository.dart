import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/estudiante.dart';

class EstudianteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referencia a la colección de usuarios
  CollectionReference get _usuariosRef => _firestore.collection('usuarios');

  // Crear un nuevo estudiante
  Future<void> agregarEstudiante(Estudiante estudiante, String docenteId) async {
    await _usuariosRef.doc(estudiante.email).set({
      'nombre': estudiante.nombre,
      'email': estudiante.email,
      'telefono': estudiante.telefono,
      'carrera': estudiante.carrera,
      'docenteId': docenteId,
      'activo': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Actualizar estado de cuenta
  Future<void> actualizarEstado(String email, bool activo) async {
    await _usuariosRef.doc(email).update({'activo': activo});
  }

  // Obtener estudiantes por docente
  Stream<List<Estudiante>> obtenerEstudiantesPorDocente(String docenteId) {
    return _usuariosRef
        .where('docenteId', isEqualTo: docenteId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Estudiante.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // Importar múltiples estudiantes
  Future<int> importarEstudiantes(
      List<Estudiante> estudiantes,
      String docenteId,
      ) async {
    final batch = _firestore.batch();
    int contador = 0;

    for (final estudiante in estudiantes) {
      // Verificar si el email ya existe
      final existe = await _usuariosRef.doc(estudiante.email).get();
      if (!existe.exists) {
        batch.set(_usuariosRef.doc(estudiante.email), {
          'nombre': estudiante.nombre,
          'email': estudiante.email,
          'telefono': estudiante.telefono,
          'carrera': estudiante.carrera,
          'docenteId': docenteId,
          'activo': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        contador++;
      }
    }

    await batch.commit();
    return contador;
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_io2_examen/domain/entities/docente.dart';
import 'package:app_io2_examen/domain/entities/estudiante.dart';
import 'package:app_io2_examen/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<User?> get currentUser async => _auth.currentUser;

  @override
  Future<void> crearDocentePrueba() async {
    final docente = Docente(
      id: 'docente_prueba_001',
      nombre: 'Ramiro Luján',
      email: 'rlujan@ucb.edu.bo',
      telefono: '70712679',
      esAdmin: true,
    );

    try {
      // Crear usuario de autenticación
      await _auth.createUserWithEmailAndPassword(
        email: docente.email,
        password: 'admin12',
      );

      // Guardar datos en Firestore
      await _firestore.collection('docentes').doc(docente.id).set(docente.toMap());
    } catch (e) {
      // Usuario ya existe, no es problema
    }
  }

  @override
  Future<void> registrarEstudiante(Estudiante estudiante, String password) async {
    try {
      // Crear usuario en Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: estudiante.email,
        password: password,
      );

      // Guardar datos adicionales en Firestore
      await _firestore.collection('usuarios').doc(estudiante.email).set({
        ...estudiante.toMap(),
        'uid': userCredential.user?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al registrar estudiante: ${e.toString()}');
    }
  }

  @override
  Future<void> eliminarUsuario(String email) async {
    try {
      // Eliminar de Authentication
      final user = _auth.currentUser;
      if (user != null && user.email == email) {
        await user.delete();
      }

      // Eliminar de Firestore
      await _firestore.collection('usuarios').doc(email).delete();
    } catch (e) {
      throw Exception('Error al eliminar usuario: ${e.toString()}');
    }
  }

  @override
  Future<Docente?> getDocenteByEmail(String email) async {
    final query = await _firestore.collection('docentes')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return Docente.fromFirestore(
        query.docs.first.data(),
        query.docs.first.id
    );
  }

  @override
  Future<Estudiante?> getEstudianteByEmail(String email) async {
    final doc = await _firestore.collection('usuarios').doc(email).get();
    if (!doc.exists) return null;

    return Estudiante.fromFirestore(doc.data()!);
  }
}
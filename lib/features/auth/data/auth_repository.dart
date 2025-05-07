import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/docente.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Docente de prueba predefinido
  static var docentePrueba = Docente(
    id: 'docente_prueba_001',
    nombre: 'Ramiro Luján',
    email: 'rlujan@ucb.edu.bo',
    telefono: '70712679',
    esAdmin: true,
  );

  Future<void> crearDocentePrueba() async {
    final docRef = _firestore.collection('docentes').doc(docentePrueba.id);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set(docentePrueba.toMap());

      // Crear usuario de autenticación
      try {
        await _auth.createUserWithEmailAndPassword(
          email: docentePrueba.email,
          password: 'admin12', // Contraseña simple para desarrollo
        );
      } catch (e) {
        // El usuario ya existe, no hay problema
      }
    }
  }

  Future<Docente?> login(String email, String password) async {
    try {
      // Si es el docente de prueba, usar credenciales especiales
      if (email == docentePrueba.email && password == 'admin12') {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return docentePrueba;
      }

      // Autenticación normal para otros usuarios
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      // Obtener datos del docente desde Firestore
      final doc = await _firestore.collection('docentes').doc(user.uid).get();
      if (doc.exists) {
        return Docente.fromFirestore(doc.data()!, doc.id);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
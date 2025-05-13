import 'package:app_io2_examen/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_io2_examen/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await getUserById(userCredential.user?.uid ?? '');
    } catch (e) {
      throw Exception('Error al iniciar sesión: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async => await _auth.signOut();

  @override
  Future<User?> get currentUser async {
    final user = _auth.currentUser;
    return user != null ? await getUserById(user.uid) : null;
  }

  @override
  Future<void> registerUser(User user, String password) async {
    try {
      // Crear usuario en Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // Guardar datos en Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set(
          user.copyWith(id: userCredential.user?.uid).toMap()
      );
    } catch (e) {
      throw Exception('Error al registrar usuario: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      // Eliminar de Authentication
      final user = _auth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }

      // Eliminar de Firestore
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Error al eliminar usuario: ${e.toString()}');
    }
  }

  @override
  Future<User?> getUserById(String userId) async {
    if (userId.isEmpty) return null;

    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;

    return User.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final query = await _firestore.collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return User.fromFirestore(
      query.docs.first.data(),
      query.docs.first.id,
    );
  }
}
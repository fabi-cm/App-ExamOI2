import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_io2_examen/domain/entities/user.dart';
import 'package:app_io2_examen/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  UserRepositoryImpl({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _usersRef => _firestore.collection('users');

  @override
  Future<void> createUser(User user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) async {
    await _usersRef.doc(user.id).update(user.toMap());
  }

  @override
  Future<void> updateUserStatus(String userId, bool isActive) async {
    await _usersRef.doc(userId).update({'isActive': isActive});
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _usersRef.doc(userId).delete();
  }

  @override
  Future<User?> getUserById(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return User.fromFirestore(data as Map<String, dynamic>, doc.id);
    } catch (e) {
      debugPrint('Error getting user $userId: $e');
      return null;
    }
  }

  @override
  Stream<List<User>> getStudentsByTeacher(String teacherId) {
    return _usersRef
        .where('teacherId', isEqualTo: teacherId)
        .where('role', isEqualTo: UserRole.student.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .handleError((error) {
      debugPrint('Error al obtener estudiantes: $error');
      return Stream.value([]);
    })
        .map((snapshot) => snapshot.docs
        .map((doc) {
      try {
        final data = doc.data();
        return User.fromFirestore(data as Map<String, dynamic>, doc.id);
      } catch (e) {
        debugPrint('Error parsing user ${doc.id}: $e');
        return User(
          id: doc.id,
          name: 'Error en datos',
          email: 'error@email.com',
          isActive: false,
          role: UserRole.student,
        );
      }
    })
        .where((user) => user.name != 'Error en datos') // Filtramos los errores
        .toList());
  }

  @override
  Future<int> importStudents(List<User> students, String teacherId) async {
    final batch = _firestore.batch();
    int counter = 0;

    // Obtener IDs existentes en una sola consulta
    final existingIds = await _usersRef
        .where(FieldPath.documentId, whereIn: students.map((e) => e.id).toList())
        .get()
        .then((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());

    for (final student in students) {
      if (!existingIds.contains(student.id)) {
        final studentWithTeacher = student.copyWith(teacherId: teacherId);
        batch.set(_usersRef.doc(student.id), studentWithTeacher.toMap());
        counter++;
      }
    }

    if (counter > 0) {
      await batch.commit();
    }
    return counter;
  }

  @override
  Stream<List<User>> getAllTeachers() {
    return _usersRef
        .where('role', isEqualTo: UserRole.teacher.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) {
      final data = doc.data();
      if (data == null) {
        debugPrint('Documento ${doc.id} tiene datos nulos');
        return User(
          id: doc.id,
          name: 'Usuario no válido',
          email: 'invalid@email.com',
          isActive: false,
          role: UserRole.student,
        );
      }
      return User.fromFirestore(data as Map<String, dynamic>, doc.id);
    })
        .where((user) => user.name != 'Usuario no válido') // Filtramos los inválidos
        .toList());
  }

  @override
  Future<void> assignStudentsToTeacher(
      String teacherId, List<String> studentIds) async {
    final batch = _firestore.batch();

    for (final studentId in studentIds) {
      batch.update(_usersRef.doc(studentId), {
        'teacherId': teacherId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
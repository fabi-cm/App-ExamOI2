import 'package:app_io2_examen/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserStatus(String userId, bool isActive);
  Future<void> deleteUser(String userId);
  Future<User?> getUserById(String userId);
  Stream<List<User>> getStudentsByTeacher(String teacherId);
  Future<int> importStudents(List<User> students, String teacherId);
  Stream<List<User>> getAllTeachers();
  Future<void> assignStudentsToTeacher(String teacherId, List<String> studentIds);
}
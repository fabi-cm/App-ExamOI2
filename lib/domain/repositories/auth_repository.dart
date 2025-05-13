import 'package:app_io2_examen/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<void> logout();
  Future<User?> get currentUser;
  Future<void> registerUser(User user, String password);
  Future<void> deleteUser(String userId);
  Future<User?> getUserById(String userId);
  Future<User?> getUserByEmail(String email);
}
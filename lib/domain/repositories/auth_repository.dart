import 'package:firebase_auth/firebase_auth.dart';
import '../entities/docente.dart';
import '../entities/estudiante.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<void> logout();
  Future<User?> get currentUser;
  Future<void> crearDocentePrueba();
  Future<void> registrarEstudiante(Estudiante estudiante, String password);
  Future<void> eliminarUsuario(String email);
  Future<Docente?> getDocenteByEmail(String email);
  Future<Estudiante?> getEstudianteByEmail(String email);
}
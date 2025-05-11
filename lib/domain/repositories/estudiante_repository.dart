import '../entities/estudiante.dart';

abstract class EstudianteRepository {
  Future<void> agregarEstudiante(Estudiante estudiante, String docenteId);
  Future<void> actualizarEstudiante(Estudiante estudiante);
  Future<void> actualizarEstado(String email, bool activo);
  Future<void> eliminarEstudiante(String email);
  Future<void> eliminarTodosEstudiantes(String docenteId);
  Stream<List<Estudiante>> obtenerEstudiantesPorDocente(String docenteId);
  Future<int> importarEstudiantes(List<Estudiante> estudiantes, String docenteId);
}
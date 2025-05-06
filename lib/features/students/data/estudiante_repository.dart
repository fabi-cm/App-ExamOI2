import '../domain/estudiante.dart';

class EstudianteRepository {
  static final EstudianteRepository _instance = EstudianteRepository._internal();
  final List<Estudiante> _estudiantes = [];

  EstudianteRepository._internal();

  factory EstudianteRepository() => _instance;

  List<Estudiante> get estudiantes => _estudiantes;

  void agregar(Estudiante e) {
    if (!_estudiantes.any((x) => x.email == e.email || x.id == e.id)) {
      _estudiantes.add(e);
    }
  }

  void agregarTodos(List<Estudiante> nuevos) {
    for (final e in nuevos) {
      agregar(e);
    }
  }
}
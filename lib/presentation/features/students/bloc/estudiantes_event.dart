part of 'estudiantes_bloc.dart';

abstract class EstudiantesEvent extends Equatable {
  const EstudiantesEvent();

  @override
  List<Object> get props => [];
}

class LoadEstudiantes extends EstudiantesEvent {
  final String? initialQuery;
  const LoadEstudiantes({this.initialQuery});
}

class SearchEstudiantes extends EstudiantesEvent {
  final String query;
  const SearchEstudiantes({required this.query});
}

class ImportEstudiantes extends EstudiantesEvent {
  final List<Estudiante> estudiantes;
  const ImportEstudiantes({required this.estudiantes});
}

class ToggleEstudianteStatus extends EstudiantesEvent {
  final String email;
  final bool activo;
  const ToggleEstudianteStatus({
    required this.email,
    required this.activo,
  });
}

class DeleteEstudiante extends EstudiantesEvent {
  final String email;
  const DeleteEstudiante({required this.email});
}

class DeleteAllEstudiantes extends EstudiantesEvent {
  const DeleteAllEstudiantes();
}
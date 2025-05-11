part of 'estudiantes_bloc.dart';

abstract class EstudiantesState extends Equatable {
  const EstudiantesState();

  @override
  List<Object> get props => [];
}

class EstudiantesInitial extends EstudiantesState {}

class EstudiantesLoading extends EstudiantesState {}

class EstudiantesLoaded extends EstudiantesState {
  final List<Estudiante> allEstudiantes;
  final List<Estudiante> filteredEstudiantes;
  final String searchQuery;

  const EstudiantesLoaded({
    required this.allEstudiantes,
    required this.filteredEstudiantes,
    this.searchQuery = '',
  });

  EstudiantesLoaded copyWith({
    List<Estudiante>? allEstudiantes,
    List<Estudiante>? filteredEstudiantes,
    String? searchQuery,
  }) {
    return EstudiantesLoaded(
      allEstudiantes: allEstudiantes ?? this.allEstudiantes,
      filteredEstudiantes: filteredEstudiantes ?? this.filteredEstudiantes,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [allEstudiantes, filteredEstudiantes, searchQuery];
}

class EstudiantesImporting extends EstudiantesState {}

class EstudiantesImportSuccess extends EstudiantesState {
  final int count;
  const EstudiantesImportSuccess(this.count);
}

class EstudiantesError extends EstudiantesState {
  final String message;
  const EstudiantesError(this.message);
}
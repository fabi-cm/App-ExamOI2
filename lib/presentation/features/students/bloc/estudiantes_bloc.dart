import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:app_io2_examen/domain/entities/estudiante.dart';
import 'package:app_io2_examen/domain/repositories/estudiante_repository.dart';

part 'estudiantes_event.dart';
part 'estudiantes_state.dart';

class EstudiantesBloc extends Bloc<EstudiantesEvent, EstudiantesState> {
  final EstudianteRepository estudianteRepository;
  final String docenteId;
  StreamSubscription? _estudiantesSubscription;

  EstudiantesBloc({
    required this.estudianteRepository,
    required this.docenteId,
  }) : super(EstudiantesInitial()) {
    on<LoadEstudiantes>(_onLoadEstudiantes);
    on<SearchEstudiantes>(_onSearchEstudiantes);
    on<ImportEstudiantes>(_onImportEstudiantes);
    on<ToggleEstudianteStatus>(_onToggleEstudianteStatus);
  }

  void _onLoadEstudiantes(
      LoadEstudiantes event,
      Emitter<EstudiantesState> emit,
      ) async {
    emit(EstudiantesLoading());

    _estudiantesSubscription?.cancel();
    _estudiantesSubscription = estudianteRepository
        .obtenerEstudiantesPorDocente(docenteId)
        .listen((estudiantes) {
      add(SearchEstudiantes(query: event.initialQuery ?? ''));
    });
  }

  void _onSearchEstudiantes(
      SearchEstudiantes event,
      Emitter<EstudiantesState> emit,
      ) {
    if (state is EstudiantesLoaded) {
      final currentState = state as EstudiantesLoaded;
      final filtered = event.query.isEmpty
          ? currentState.allEstudiantes
          : currentState.allEstudiantes.where((e) =>
      e.nombre.toLowerCase().contains(event.query.toLowerCase()) ||
          e.email.toLowerCase().contains(event.query.toLowerCase())).toList();

      emit(currentState.copyWith(
        filteredEstudiantes: filtered,
        searchQuery: event.query,
      ));
    }
  }

  void _onDeleteEstudiante(
      DeleteEstudiante event,
      Emitter<EstudiantesState> emit,
      ) async {
    try {
      await estudianteRepository.eliminarEstudiante(event.email);
      add(LoadEstudiantes());
    } catch (e) {
      emit(EstudiantesError('Error al eliminar estudiante: ${e.toString()}'));
    }
  }

  void _onDeleteAllEstudiantes(
      DeleteAllEstudiantes event,
      Emitter<EstudiantesState> emit,
      ) async {
    try {
      emit(EstudiantesLoading());
      await estudianteRepository.eliminarTodosEstudiantes(docenteId);
      add(LoadEstudiantes());
    } catch (e) {
      emit(EstudiantesError('Error al eliminar estudiantes: ${e.toString()}'));
    }
  }

  Future<void> _onImportEstudiantes(
      ImportEstudiantes event,
      Emitter<EstudiantesState> emit,
      ) async {
    try {
      emit(EstudiantesImporting());

      final nuevos = event.estudiantes;
      final contador = await estudianteRepository.importarEstudiantes(
        nuevos,
        docenteId,
      );

      emit(EstudiantesImportSuccess(contador));
      add(LoadEstudiantes());
    } catch (e) {
      emit(EstudiantesError('Error al importar: ${e.toString()}'));
    }
  }

  Future<void> _onToggleEstudianteStatus(
      ToggleEstudianteStatus event,
      Emitter<EstudiantesState> emit,
      ) async {
    try {
      await estudianteRepository.actualizarEstado(
        event.email,
        event.activo,
      );
    } catch (e) {
      emit(EstudiantesError('Error al actualizar estado: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _estudiantesSubscription?.cancel();
    return super.close();
  }
}
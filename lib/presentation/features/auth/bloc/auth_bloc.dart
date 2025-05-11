import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:app_io2_examen/domain/entities/docente.dart';
import 'package:app_io2_examen/domain/repositories/auth_repository.dart';

import '../../../../domain/entities/estudiante.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FirebaseFirestore firestore;

  AuthBloc({
    required this.authRepository,
    required this.firestore,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<VerifyAuthStatus>(_onVerifyAuthStatus);
    on<RegisterStudentRequested>(_onRegisterStudentRequested);
    on<DeleteUserRequested>(_onDeleteUserRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(event.email, event.password);
      if (user != null) {
        // Verificar si es docente o estudiante
        final docente = await authRepository.getDocenteByEmail(event.email);
        if (docente != null) {
          emit(AuthSuccess(docente));
        } else {
          // Obtener datos del estudiante
          final estudiante = await authRepository.getEstudianteByEmail(event.email);
          if (estudiante != null) {
            emit(StudentAuthSuccess(estudiante));
          } else {
            emit(const AuthError('Usuario no encontrado'));
          }
        }
      } else {
        emit(const AuthError('Credenciales incorrectas'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyAuthStatus(
      VerifyAuthStatus event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final currentUser = await authRepository.currentUser;
      if (currentUser != null) {
        final email = currentUser.email;
        if (email != null) {
          final docente = await authRepository.getDocenteByEmail(email);
          if (docente != null) {
            emit(AuthSuccess(docente));
          } else {
            final estudiante = await authRepository.getEstudianteByEmail(email);
            if (estudiante != null) {
              emit(StudentAuthSuccess(estudiante));
            } else {
              emit(const AuthError('Usuario no registrado correctamente'));
            }
          }
        }
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterStudentRequested(
      RegisterStudentRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await authRepository.registrarEstudiante(event.estudiante, event.password);
      emit(StudentAuthSuccess(event.estudiante));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onDeleteUserRequested(
      DeleteUserRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await authRepository.eliminarUsuario(event.email);
      emit(UserDeletedSuccessfully());
      add(VerifyAuthStatus());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
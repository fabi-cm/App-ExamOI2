import 'package:app_io2_examen/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:app_io2_examen/domain/entities/user.dart';
import 'package:app_io2_examen/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<VerifyAuthStatus>(_onVerifyAuthStatus);
    on<RegisterUserRequested>(_onRegisterUserRequested);
    on<DeleteUserRequested>(_onDeleteUserRequested);
    on<CreateTestAdminRequested>(_onCreateTestAdminRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(event.email, event.password);
      if (user != null) {
        final userData = await _userRepository.getUserById(user.id);
        if (userData != null) {
          emit(AuthSuccess(userData));
        } else {
          emit(const AuthError('Datos de usuario no encontrados'));
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
      await _authRepository.logout();
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
      final currentUser = await _authRepository.currentUser;
      if (currentUser != null) {
        emit(AuthSuccess(currentUser));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterUserRequested(
      RegisterUserRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      // Si es estudiante y tiene teacherId, lo asignamos
      final userToRegister = event.teacherId != null && event.user.isStudent
          ? event.user.copyWith(teacherId: event.teacherId)
          : event.user;

      await _authRepository.registerUser(userToRegister, event.password);
      emit(AuthSuccess(userToRegister));
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
      await _authRepository.deleteUser(event.userId);
      emit(UserDeletedSuccessfully());
      add(VerifyAuthStatus());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCreateTestAdminRequested(
      CreateTestAdminRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final testAdmin = User(
        id: 'admin_test_001',
        name: 'Admin Test',
        email: 'admin@test.com',
        isActive: true,
        role: UserRole.admin,
      );

      await _authRepository.registerUser(testAdmin, 'admin123');
      emit(TestAdminCreated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
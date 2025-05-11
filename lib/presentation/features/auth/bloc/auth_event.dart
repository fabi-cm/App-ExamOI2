part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

class VerifyAuthStatus extends AuthEvent {}

class RegisterStudentRequested extends AuthEvent {
  final Estudiante estudiante;
  final String password;

  const RegisterStudentRequested({
    required this.estudiante,
    required this.password,
  });

  @override
  List<Object> get props => [estudiante, password];
}

class DeleteUserRequested extends AuthEvent {
  final String email;

  const DeleteUserRequested({required this.email});

  @override
  List<Object> get props => [email];
}
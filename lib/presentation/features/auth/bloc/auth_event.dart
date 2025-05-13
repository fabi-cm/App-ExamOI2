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

class RegisterUserRequested extends AuthEvent {
  final User user;
  final String password;
  final String? teacherId; // Para estudiantes

  const RegisterUserRequested({
    required this.user,
    required this.password,
    this.teacherId,
  });

  @override
  List<Object> get props => [user, password];
}

class DeleteUserRequested extends AuthEvent {
  final String userId;

  const DeleteUserRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CreateTestAdminRequested extends AuthEvent {}
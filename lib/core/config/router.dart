import 'package:app_io2_examen/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:app_io2_examen/presentation/features/auth/pages/login_page.dart';
import 'package:app_io2_examen/presentation/features/exams/presentation/admin_dashboard.dart';
import 'package:app_io2_examen/presentation/features/students/pages/student_dashboard.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => LoginPage(),
    ),
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (_, __) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/student',
      name: 'student',
      builder: (_, __) => const StudentDashboard(),
    ),
  ],
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isLoggedIn = authState is AuthSuccess;
    final isLoggingIn = state.uri.path == '/login';

    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }

    if (isLoggedIn) {
      final user = (authState).user;

      if (isLoggingIn) {
        return user.isAdmin || user.isTeacher ? '/admin' : '/student';
      }

      // Verificar que la ruta coincida con el rol
      if (user.isStudent && state.uri.path == '/admin') {
        return '/student';
      } else if ((user.isAdmin || user.isTeacher) && state.uri.path == '/student') {
        return '/admin';
      }
    }

    return null;
  },
);
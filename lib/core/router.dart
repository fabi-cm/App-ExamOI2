import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/students/presentation/student_dashboard.dart';
import '../features/exams/presentation/admin_dashboard.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/admin', builder: (_, __) => const AdminDashboard()),
    GoRoute(path: '/student', builder: (_, __) => const StudentDashboard()),
  ],
);
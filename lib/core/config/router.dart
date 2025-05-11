import 'package:go_router/go_router.dart';
import '../../presentation/features/auth/pages/login_page.dart';
import '../../presentation/features/exams/presentation/admin_dashboard.dart';
import '../../presentation/features/students/pages/student_dashboard.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => LoginPage()),
    GoRoute(path: '/admin', builder: (_, __) => const AdminDashboard()),
    GoRoute(path: '/student', builder: (_, __) => const StudentDashboard()),
  ],
);
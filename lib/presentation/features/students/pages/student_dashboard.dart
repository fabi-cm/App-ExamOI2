import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app_io2_examen/presentation/features/auth/bloc/auth_bloc.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthSuccess).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('🎓 Bienvenido ${user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              context.go('/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.quiz, size: 40),
              title: const Text('📝 Rendir Examen'),
              subtitle: const Text('Realiza el examen de la unidad'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history, size: 40),
              title: const Text('📜 Historial de Calificaciones'),
              subtitle: const Text('Revisa tus calificaciones anteriores'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.help, size: 40),
              title: const Text('🧠 Modelos y Fórmulas de Ayuda'),
              subtitle: const Text('Material de apoyo para tu examen'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app_io2_examen/presentation/features/auth/bloc/auth_bloc.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthSuccess).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de ${user.isAdmin ? 'Administración' : 'Docente'}'),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.people,
              title: 'Gestión de Estudiantes',
              onTap: () => context.push('/students'),
            ),
            if (user.isAdmin) ...[
              _buildDashboardCard(
                context,
                icon: Icons.school,
                title: 'Gestión de Docentes',
                onTap: () {},
              ),
              _buildDashboardCard(
                context,
                icon: Icons.settings,
                title: 'Configuración del Sistema',
                onTap: () {},
              ),
            ],
            _buildDashboardCard(
              context,
              icon: Icons.assignment,
              title: 'Ejercicios',
              onTap: () {},
            ),
            _buildDashboardCard(
              context,
              icon: Icons.quiz,
              title: 'Configurar Examen',
              onTap: () {},
            ),
            _buildDashboardCard(
              context,
              icon: Icons.analytics,
              title: 'Estadísticas',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
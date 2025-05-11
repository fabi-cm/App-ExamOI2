import 'package:flutter/material.dart';
import 'package:app_io2_examen/presentation/features/students/pages/estudiantes_list_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        centerTitle: true,
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EstudiantesListPage(docenteId: 'Admin'),
                ),
              ),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.assignment,
              title: 'Ejercicios',
              // color: Colors.green,
              onTap: () {},
            ),
            _buildDashboardCard(
              context,
              icon: Icons.quiz,
              title: 'Configurar Examen',
              // color: Colors.orange,
              onTap: () {},
            ),
            _buildDashboardCard(
              context,
              icon: Icons.analytics,
              title: 'Estadísticas',
              // color: Colors.purple,
              onTap: () {},
            ),
            _buildDashboardCard(
              context,
              icon: Icons.settings,
              title: 'Configuración',
              // color: Colors.redAccent,
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
import 'package:flutter/material.dart';
import '../../students/presentation/estudiantes_list_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👨‍💼 Menú Admin')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('📚 Gestión de Estudiantes'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EstudiantesListPage()),
            ),
          ),
          ListTile(
            title: const Text('✏️ Cargar/Editar Ejercicios'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('📝 Configurar Examen'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('📊 Ver Estadísticas'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('🔐 Seguridad / Configuración avanzada'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
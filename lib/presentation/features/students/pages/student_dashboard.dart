import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎓 Bienvenido Estudiante')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('📝 Rendir Examen'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('📜 Historial de Calificaciones'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('🧠 Modelos y Fórmulas de Ayuda'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
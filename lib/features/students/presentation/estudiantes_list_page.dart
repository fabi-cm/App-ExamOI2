import 'package:flutter/material.dart';
import '../../students/domain/estudiante.dart';

class EstudiantesListPage extends StatelessWidget {
  final List<Estudiante> estudiantes;

  const EstudiantesListPage({super.key, required this.estudiantes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📋 Lista de Estudiantes')),
      body: ListView.builder(
        itemCount: estudiantes.length,
        itemBuilder: (context, index) {
          final e = estudiantes[index];
          return ListTile(
            title: Text(e.nombre),
            subtitle: Text('${e.email} | ${e.telefono}'),
            trailing: Text(e.carrera),
          );
        },
      ),
    );
  }
}
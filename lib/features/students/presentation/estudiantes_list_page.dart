import 'package:flutter/material.dart';
import '../domain/estudiante.dart';
import '../application/importar_estudiantes.dart';
import '../data/estudiante_repository.dart';

class EstudiantesListPage extends StatefulWidget {
  const EstudiantesListPage({super.key});

  @override
  State<EstudiantesListPage> createState() => _EstudiantesListPageState();
}

class _EstudiantesListPageState extends State<EstudiantesListPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Estudiante> get _filtrados {
    final query = _searchController.text.toLowerCase();
    return EstudianteRepository().estudiantes.where((e) =>
    e.nombre.toLowerCase().contains(query) || e.email.toLowerCase().contains(query)).toList();
  }

  void _importar() async {
    final nuevos = await importarDesdeExcel(
      EstudianteRepository().estudiantes.map((e) => e.email).toSet(),
    );
    setState(() {
      EstudianteRepository().agregarTodos(nuevos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📋 Estudiantes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Buscar estudiante',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Teléfono')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Carrera')),
                  ],
                  rows: _filtrados.map((e) => DataRow(cells: [
                    DataCell(Text(e.nombre)),
                    DataCell(Text(e.telefono)),
                    DataCell(Text(e.email)),
                    DataCell(Text(e.carrera)),
                  ])).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ElevatedButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(Icons.person_add),
                //   label: const Text('Agregar estudiante'),
                // ),
                // ElevatedButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(Icons.settings),
                //   label: const Text('Configurar notas'),
                // ),
                ElevatedButton.icon(
                  onPressed: _importar,
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Importar Excel'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

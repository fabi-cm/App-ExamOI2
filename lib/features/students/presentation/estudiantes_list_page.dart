import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config.dart';
import '../application/importar_estudiantes.dart';
import '../data/estudiante_repository.dart';
import '../domain/estudiante.dart';

class EstudiantesListPage extends StatefulWidget {
  final String docenteId;

  const EstudiantesListPage({super.key, required this.docenteId});

  @override
  State<EstudiantesListPage> createState() => _EstudiantesListPageState();
}

class _EstudiantesListPageState extends State<EstudiantesListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Estudiantes'),
        actions: [
          if (_isImporting)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar estudiantes',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                // fillColor: AppConfig.primaryColor,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Estudiante>>(
              stream: context
                  .read<EstudianteRepository>()
                  .obtenerEstudiantesPorDocente(widget.docenteId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final estudiantes = snapshot.data!;
                final query = _searchController.text.toLowerCase();
                final filtrados = query.isEmpty
                    ? estudiantes
                    : estudiantes.where((e) =>
                e.nombre.toLowerCase().contains(query) ||
                    e.email.toLowerCase().contains(query));

                if (filtrados.isEmpty) {
                  return const Center(child: Text('No se encontraron estudiantes'));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Celular', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: filtrados.map((estudiante) {
                      return DataRow(cells: [
                        DataCell(Text(estudiante.nombre)),
                        DataCell(Text(estudiante.telefono)),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              estudiante.email,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Switch(
                            value: estudiante.activo,
                            onChanged: (value) async {
                              await context
                                  .read<EstudianteRepository>()
                                  .actualizarEstado(estudiante.email, value);
                            },
                            activeColor: AppConfig.primaryColor,
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Implementar edición
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  // Implementar eliminación
                                },
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'import_excel_button', // Tag único
            onPressed: _isImporting ? null : _importarExcel,
            icon: const Icon(Icons.upload),
            label: const Text('Importar Excel'),
            backgroundColor: AppConfig.primaryColor,
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'add_student_button', // Tag único diferente
            onPressed: () {
              // Implementar agregar estudiante manual
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Agregar'),
            backgroundColor: AppConfig.secondaryColor,
          ),
        ],
      ),
    );
  }

  Future<void> _importarExcel() async {
    setState(() => _isImporting = true);
    final scaffold = ScaffoldMessenger.of(context);

    try {
      final nuevos = await importarDesdeExcel({});

      if (nuevos.isEmpty) {
        scaffold.showSnackBar(
          const SnackBar(content: Text('No se encontraron estudiantes válidos')),
        );
        return;
      }

      // Mostrar vista previa
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar importación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Estudiantes a importar:'),
              const SizedBox(height: 10),
              ...nuevos.take(3).map((e) => ListTile(
                title: Text(e.nombre),
                subtitle: Text(e.email),
              )),
              if (nuevos.length > 3)
                Text('+ ${nuevos.length - 3} más...'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Importar'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final contador = await context
            .read<EstudianteRepository>()
            .importarEstudiantes(nuevos, widget.docenteId);

        scaffold.showSnackBar(
          SnackBar(
            content: Text('$contador estudiantes importados correctamente'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isImporting = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
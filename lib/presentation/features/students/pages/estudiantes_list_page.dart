import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_io2_examen/core/config/config.dart';
import 'package:app_io2_examen/presentation/features/students/bloc/estudiantes_bloc.dart';
import 'package:app_io2_examen/presentation/features/students/application/importar_estudiantes.dart';
import 'package:app_io2_examen/domain/repositories/estudiante_repository.dart';
import 'package:app_io2_examen/domain/entities/estudiante.dart';

class EstudiantesListPage extends StatefulWidget {
  final String docenteId;

  const EstudiantesListPage({super.key, required this.docenteId});

  @override
  State<EstudiantesListPage> createState() => _EstudiantesListPageState();
}

class _EstudiantesListPageState extends State<EstudiantesListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<EstudiantesBloc>().add(
      SearchEstudiantes(query: _searchController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstudiantesBloc(
        estudianteRepository: context.read<EstudianteRepository>(),
        docenteId: widget.docenteId,
      )..add(LoadEstudiantes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Estudiantes'),
          actions: [
            BlocBuilder<EstudiantesBloc, EstudiantesState>(
              builder: (context, state) {
                return PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete_all',
                      child: Text('Eliminar todos los estudiantes'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete_all') {
                      _confirmDeleteAll(context);
                    }
                  },
                );
              },
            ),
            const _ImportStatusIndicator(),
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
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<EstudiantesBloc, EstudiantesState>(
                builder: (context, state) {
                  if (state is EstudiantesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is EstudiantesError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 50, color: Colors.red),
                        const SizedBox(height: 20),
                        Text(
                          'Error al cargar estudiantes',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                          onPressed: () => context.read<EstudiantesBloc>().add(LoadEstudiantes()),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    );
                  }
                  if (state is EstudiantesLoaded) {
                    return _buildStudentTable(state.filteredEstudiantes);
                  }
                  return const Center(child: Text('Estado desconocido'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: const _StudentActionsButtons(),
      ),
    );
  }

  Widget _buildStudentTable(List<Estudiante> estudiantes) {
    if (estudiantes.isEmpty) {
      return const Center(child: Text('No se encontraron estudiantes'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Celular')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: estudiantes.map((estudiante) {
                return DataRow(cells: [
                  DataCell(
                    SizedBox(
                      width: 150,
                      child: Text(
                        estudiante.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
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
                      onChanged: (value) {
                        context.read<EstudiantesBloc>().add(
                          ToggleEstudianteStatus(
                            email: estudiante.email,
                            activo: value,
                          ),
                        );
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
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: Text('¿Eliminar a ${estudiante.nombre}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<EstudiantesBloc>().add(
                                        DeleteEstudiante(email: estudiante.email),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar TODOS los estudiantes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<EstudiantesBloc>().add(DeleteAllEstudiantes());
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}

class _ImportStatusIndicator extends StatelessWidget {
  const _ImportStatusIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EstudiantesBloc, EstudiantesState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: state is EstudiantesImporting
              ? const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class _StudentActionsButtons extends StatelessWidget {
  const _StudentActionsButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: 'import_excel_button',
          onPressed: () => _importarExcel(context),
          icon: const Icon(Icons.upload),
          label: const Text('Importar Excel'),
          backgroundColor: AppConfig.primaryColor,
        ),
        const SizedBox(height: 16),
        FloatingActionButton.extended(
          heroTag: 'add_student_button',
          onPressed: () {
            // Implementar agregar estudiante manual
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Agregar'),
          backgroundColor: AppConfig.secondaryColor,
        ),
      ],
    );
  }

  Future<void> _importarExcel(BuildContext context) async {
    final bloc = context.read<EstudiantesBloc>();
    final scaffold = ScaffoldMessenger.of(context);

    try {
      final nuevos = await importarDesdeExcel({});
      if (nuevos.isEmpty) {
        scaffold.showSnackBar(
          const SnackBar(content: Text('No se encontraron estudiantes válidos')),
        );
        return;
      }

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
        bloc.add(ImportEstudiantes(estudiantes: nuevos));
      }
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
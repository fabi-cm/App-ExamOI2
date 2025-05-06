import 'package:flutter/material.dart';
import '../application/importar_estudiantes.dart';
import '../domain/estudiante.dart';

class EstudiantesListPage extends StatefulWidget {
  const EstudiantesListPage({super.key});

  @override
  State<EstudiantesListPage> createState() => _EstudiantesListPageState();
}

class _EstudiantesListPageState extends State<EstudiantesListPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Estudiante> _estudiantes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Estudiante> get _filteredStudents {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _estudiantes;

    return _estudiantes.where((est) =>
    est.nombre.toLowerCase().contains(query) ||
        est.email.toLowerCase().contains(query) ||
        est.carrera.toLowerCase().contains(query)
    ).toList();
  }

  Future<void> _importStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await importarEstudiantesExcel();

      if (result.errores.isNotEmpty) {
        _showErrorDialog(result.errores);
      }

      if (result.estudiantes.isNotEmpty) {
        setState(() {
          _estudiantes.addAll(result.estudiantes);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Importados ${result.estudiantes.length} estudiantes '
                    'en ${result.tiempoProcesamientoMs}ms',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error al importar: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(List<String> errores) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Errores de Importación'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Se encontraron los siguientes errores:'),
              const SizedBox(height: 16),
              ...errores.take(5).map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('- $e'),
              )),
              if (errores.length > 5) ...[
                const SizedBox(height: 8),
                Text('... y ${errores.length - 5} errores más'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Estudiantes'),
        actions: [
          if (_isLoading)
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
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          Expanded(
            child: _estudiantes.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.group, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No hay estudiantes registrados',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Importa un archivo Excel para comenzar'),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final est = _filteredStudents[index];
                return ListTile(
                  title: Text(est.nombre),
                  subtitle: Text(est.email),
                  trailing: Text(est.carrera),
                  onTap: () {
                    // Acción al seleccionar estudiante
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _importStudents,
        icon: const Icon(Icons.upload),
        label: const Text('Importar Excel'),
        tooltip: 'Importar estudiantes desde Excel',
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
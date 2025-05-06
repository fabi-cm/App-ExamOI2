import 'package:flutter/material.dart';

import '../domain/estudiante.dart';

class EstudianteRepository extends ChangeNotifier {
  final List<Estudiante> _estudiantes = [];

  List<Estudiante> get estudiantes => List.unmodifiable(_estudiantes);

  void agregar(Estudiante estudiante) {
    if (!_estudiantes.contains(estudiante)) {
      _estudiantes.add(estudiante);
      notifyListeners();
    }
  }

  void agregarTodos(List<Estudiante> nuevosEstudiantes) {
    bool cambios = false;
    for (final estudiante in nuevosEstudiantes) {
      if (!_estudiantes.contains(estudiante)) {
        _estudiantes.add(estudiante);
        cambios = true;
      }
    }
    if (cambios) notifyListeners();
  }

  void clear() {
    _estudiantes.clear();
    notifyListeners();
  }
}
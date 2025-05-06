import 'package:excel/excel.dart';

class Estudiante {
  final int id;
  final String nombre;
  final String carrera;
  final String telefono;
  final String email;

  Estudiante({
    required this.id,
    required this.nombre,
    required this.carrera,
    required this.telefono,
    required this.email,
  });

  factory Estudiante.fromExcelRow(List<Data?> row) {
    // Función mejorada para extraer y limpiar valores de celdas
    String obtenerValorCelda(Data? cell) {
      if (cell == null || cell.value == null) return '';

      final value = cell.value;

      // Manejar diferentes tipos de datos de Excel
      if (value is String) {
        return value.toString().trim();
      } else if (value is num) {
        return value.toString();
      } else if (value is bool) {
        return value.toString();
      // } else if (value is DateTime) {
      //   return value?.toIso8601String();
      } else {
        return value.toString().trim();
      }
    }

    // Validar y extraer el ID
    final idStr = obtenerValorCelda(row[0]).replaceAll(RegExp(r'\D'), '');
    final id = int.tryParse(idStr) ?? 0;

    // Validar y extraer el nombre
    final nombre = obtenerValorCelda(row[1]);
    if (nombre.isEmpty) {
      throw const FormatException('El campo nombre no puede estar vacío');
    }

    // Validar y extraer la carrera
    final carrera = obtenerValorCelda(row[2]);
    if (carrera.isEmpty) {
      throw const FormatException('El campo carrera no puede estar vacío');
    }

    // Validar y extraer el teléfono
    final telefono = obtenerValorCelda(row[3]).replaceAll(RegExp(r'\D'), '');
    if (telefono.length < 7 || telefono.length > 15) {
      throw FormatException('Teléfono inválido: $telefono');
    }

    // Validar y extraer el email
    final email = obtenerValorCelda(row[4]).toLowerCase();
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw FormatException('Email inválido: $email');
    }

    return Estudiante(
      id: id,
      nombre: nombre,
      carrera: carrera,
      telefono: telefono,
      email: email,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Estudiante &&
              runtimeType == other.runtimeType &&
              email == other.email;

  @override
  int get hashCode => email.hashCode;

  @override
  String toString() {
    return 'Estudiante{id: $id, nombre: $nombre, carrera: $carrera, telefono: $telefono, email: $email}';
  }
}
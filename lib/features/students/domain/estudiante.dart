import 'package:excel/excel.dart';

class Estudiante {
  final String nombre;
  final String carrera;
  final String telefono;
  final String email;
  final bool activo;

  Estudiante({
    required this.nombre,
    required this.carrera,
    required this.telefono,
    required this.email,
    this.activo = true,
  });

  factory Estudiante.fromFirestore(Map<String, dynamic> data) {
    return Estudiante(
      nombre: data['nombre'] ?? '',
      carrera: data['carrera'] ?? '',
      telefono: data['telefono']?.toString() ?? '',
      email: data['email'] ?? '',
      activo: data['activo'] ?? false,
    );
  }

  factory Estudiante.fromExcelRow(List<dynamic> row) {
    dynamic obtenerValor(dynamic celda) {
      if (celda == null) return '';
      // Si la celda tiene una propiedad 'value', la usamos
      try {
        return celda.value?.toString().trim() ?? '';
      } catch (e) {
        // Si no tiene propiedad 'value', usamos la celda directamente
        return celda.toString().trim();
      }
    }

    String limpiarTelefono(String telefono) {
      return telefono.replaceAll(RegExp(r'[^0-9]'), '').padLeft(8, '0').substring(0, 8);
    }

    return Estudiante(
      nombre: obtenerValor(row[1]),
      carrera: obtenerValor(row[2]),
      telefono: limpiarTelefono(obtenerValor(row[3])),
      email: obtenerValor(row[4]).toLowerCase(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'carrera': carrera,
      'telefono': telefono,
      'email': email,
      'activo': activo,
    };
  }
}
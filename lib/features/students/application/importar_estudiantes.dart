import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import '../domain/estudiante.dart';

Future<List<Estudiante>> importarDesdeExcel(Set<String> emailsExistentes) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return [];

    final file = result.files.first;
    if (file.bytes == null || file.bytes!.isEmpty) return [];

    final excel = Excel.decodeBytes(file.bytes!);
    final estudiantes = <Estudiante>[];
    final nuevosEmails = <String>{};

    for (final table in excel.tables.keys) {
      final rows = excel.tables[table]!.rows;

      // Saltar encabezados
      final startRow = rows.length > 0 ? 1 : 0;

      for (int i = startRow; i < rows.length; i++) {
        try {
          final row = rows[i];
          // Saltar filas vacías
          if (row.length < 5 || row.every((cell) => cell?.value == null)) continue;

          final estudiante = Estudiante.fromExcelRow(row);
          if (estudiante.email.isNotEmpty &&
              estudiante.email.contains('@') &&
              !emailsExistentes.contains(estudiante.email) &&
              !nuevosEmails.contains(estudiante.email)) {
            estudiantes.add(estudiante);
            nuevosEmails.add(estudiante.email);
          }
        } catch (e) {
          debugPrint('Error procesando fila $i: $e');
        }
      }
    }

    return estudiantes;
  } catch (e) {
    debugPrint('Error al procesar archivo Excel: $e');
    throw Exception('Formato de archivo no válido. Por favor use la plantilla proporcionada.');
  }
}
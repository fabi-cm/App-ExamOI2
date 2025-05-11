import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:app_io2_examen/domain/entities/estudiante.dart';

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

    return await compute(
      _processExcelInBackground,
      {
        'bytes': file.bytes!,
        'emailsExistentes': emailsExistentes.toList(),
      },
    );
  } catch (e) {
    debugPrint('Error al procesar archivo Excel: $e');
    throw Exception('Formato de archivo no válido. Por favor use la plantilla proporcionada.');
  }
}

List<Estudiante> _processExcelInBackground(Map<String, dynamic> params) {
  final bytes = params['bytes'] as Uint8List;
  final emailsExistentes = (params['emailsExistentes'] as List).cast<String>().toSet();

  final excel = Excel.decodeBytes(bytes);
  final estudiantes = <Estudiante>[];
  final nuevosEmails = <String>{};

  for (final table in excel.tables.keys) {
    final rows = excel.tables[table]!.rows;
    if (rows.isEmpty) continue;

    // Asumimos que la primera fila son encabezados
    for (int i = 1; i < rows.length; i++) {
      try {
        final row = rows[i];
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
}
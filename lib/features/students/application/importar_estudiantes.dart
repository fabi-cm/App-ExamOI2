import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import '../domain/estudiante.dart';

class ImportResult {
  final List<Estudiante> estudiantes;
  final List<String> errores;
  final int tiempoProcesamientoMs;

  ImportResult({
    required this.estudiantes,
    required this.errores,
    required this.tiempoProcesamientoMs,
  });
}

Future<ImportResult> _procesarExcelEnIsolate(List<int> bytes) async {
  final stopwatch = Stopwatch()..start();
  final estudiantes = <Estudiante>[];
  final errores = <String>[];

  try {
    final excel = Excel.decodeBytes(bytes);

    for (final table in excel.tables.keys) {
      final rows = excel.tables[table]!.rows;

      // Saltar encabezados si existen
      final startRow = rows.length > 1 &&
          rows[0].any((cell) => cell?.value.toString().contains('ESTUDIANTE') ?? false)
          ? 1 : 0;

      for (int i = startRow; i < rows.length; i++) {
        try {
          final estudiante = Estudiante.fromExcelRow(rows[i]);
          if (estudiante.email.isNotEmpty) {
            estudiantes.add(estudiante);
          }
        } catch (e, stack) {
          errores.add('Fila ${i + 1}: ${e.toString()}');
          if (kDebugMode) {
            print('Error en fila $i: $e\n$stack');
          }
        }
      }
    }
  } catch (e, stack) {
    errores.add('Error al procesar archivo: ${e.toString()}');
    if (kDebugMode) {
      print('Error procesando Excel: $e\n$stack');
    }
  }

  stopwatch.stop();
  return ImportResult(
    estudiantes: estudiantes,
    errores: errores,
    tiempoProcesamientoMs: stopwatch.elapsedMilliseconds,
  );
}

Future<ImportResult> importarEstudiantesExcel() async {
  try {
    // Selección de archivo
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return ImportResult(
        estudiantes: [],
        errores: ['Operación cancelada por el usuario'],
        tiempoProcesamientoMs: 0,
      );
    }

    final file = result.files.single;
    if (file.bytes == null || file.bytes!.isEmpty) {
      return ImportResult(
        estudiantes: [],
        errores: ['El archivo está vacío'],
        tiempoProcesamientoMs: 0,
      );
    }

    // Procesamiento en isolate separado
    return await compute(
      _procesarExcelEnIsolate,
      file.bytes!,
    );
  } catch (e, stack) {
    if (kDebugMode) {
      print('Error en importarEstudiantesExcel: $e\n$stack');
    }
    return ImportResult(
      estudiantes: [],
      errores: ['Error inesperado: ${e.toString()}'],
      tiempoProcesamientoMs: 0,
    );
  }
}
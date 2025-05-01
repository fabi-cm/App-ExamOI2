import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import '../domain/estudiante.dart';

Future<List<Estudiante>> importarDesdeExcel(Set<String> emailsExistentes) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result == null || result.files.single.bytes == null) return [];

  final bytes = result.files.single.bytes!;
  final excel = Excel.decodeBytes(bytes);

  final List<Estudiante> estudiantes = [];
  final Set<String> nuevosEmails = {};

  for (var table in excel.tables.keys) {
    final rows = excel.tables[table]!.rows;
    for (int i = 1; i < rows.length; i++) {
      try {
        final estudiante = Estudiante.fromExcelRow(rows[i]);
        if (!emailsExistentes.contains(estudiante.email) && !nuevosEmails.contains(estudiante.email)) {
          estudiantes.add(estudiante);
          nuevosEmails.add(estudiante.email);
        }
      } catch (_) {
        // Ignorar filas mal formateadas
      }
    }
  }

  return estudiantes;
}
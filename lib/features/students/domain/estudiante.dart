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

  factory Estudiante.fromExcelRow(List<dynamic> row) {
    String limpiar(dynamic val) => val?.toString().trim().replaceAll(RegExp(r'\s+'), ' ') ?? '';

    final idRaw = row[0]?.toString() ?? '';
    final id = int.tryParse(idRaw.replaceAll(RegExp(r'\D'), '')) ?? 0;

    final email = limpiar(row[4]).toLowerCase();

    return Estudiante(
      id: id,
      nombre: limpiar(row[1]),
      carrera: limpiar(row[2]),
      telefono: limpiar(row[3]),
      email: email,
    );
  }
}
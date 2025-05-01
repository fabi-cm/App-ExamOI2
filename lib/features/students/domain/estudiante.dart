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
    return Estudiante(
      id: int.tryParse(row[0].toString()) ?? 0,
      nombre: row[1]?.toString().trim() ?? '',
      carrera: row[2]?.toString().trim() ?? '',
      telefono: row[3]?.toString().trim() ?? '',
      email: row[4]?.toString().trim() ?? '',
    );
  }
}
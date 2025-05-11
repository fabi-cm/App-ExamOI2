class Docente {
  final String id;
  final String nombre;
  final String email;
  final String telefono;
  final bool esAdmin;

  Docente({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    this.esAdmin = false,
  });

  factory Docente.fromFirestore(Map<String, dynamic> data, String id) {
    return Docente(
      id: id,
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      telefono: data['telefono']?.toString() ?? '',
      esAdmin: data['esAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'esAdmin': esAdmin,
    };
  }
}
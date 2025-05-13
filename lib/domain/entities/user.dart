import 'package:equatable/equatable.dart';

enum UserRole { admin, teacher, student }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone; // Mejor nombre en inglés
  final String? career; // Carrera (para estudiantes)
  final bool isActive;
  final UserRole role;
  final DateTime? createdAt;
  final String? teacherId; // Para estudiantes, referencia a su docente
  final List<String>? students; // Solo para profesores, IDs de estudiantes

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.career,
    this.isActive = true,
    required this.role,
    this.createdAt,
    this.teacherId,
    this.students,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? career,
    bool? isActive,
    UserRole? role,
    DateTime? createdAt,
    String? teacherId,
    List<String>? students,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      career: career ?? this.career,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      teacherId: teacherId ?? this.teacherId,
      students: students ?? this.students,
    );
  }

  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone']?.toString(),
      career: data['career']?.toString(),
      isActive: data['isActive'] as bool? ?? true,
      role: _parseRole(data['role']),
      createdAt: data['createdAt']?.toDate(),
      teacherId: data['teacherId']?.toString(),
      students: data['students'] != null
          ? List<String>.from(data['students'])
          : null,
    );
  }

  static UserRole _parseRole(dynamic role) {
    if (role == null) return UserRole.student;
    if (role is String) {
      switch (role.toLowerCase()) {
        case 'admin': return UserRole.admin;
        case 'teacher': return UserRole.teacher;
        default: return UserRole.student;
      }
    }
    return UserRole.student;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (career != null) 'career': career,
      'isActive': isActive,
      'role': role.name,
      if (createdAt != null) 'createdAt': createdAt,
      if (teacherId != null) 'teacherId': teacherId,
      if (students != null) 'students': students,
    };
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isTeacher => role == UserRole.teacher;
  bool get isStudent => role == UserRole.student;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    career,
    isActive,
    role,
    createdAt,
    teacherId,
    students,
  ];
}
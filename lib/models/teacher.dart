// lib/models/teacher.dart
class Teacher {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String dni;
  final String address;
  final String phone;
  final String username;

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dni,
    required this.address,
    required this.phone,
    required this.username,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw Exception('El campo id es nulo en Teacher');
    }
    return Teacher(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      dni: json['dni'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dni': dni,
      'address': address,
      'phone': phone,
      'username': username,
    };
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';
import '../models/teacher.dart';

class TeachersService {
  Future<List<Teacher>> getAllTeachers() async {
    final response = await http.get(Uri.parse(ApiConfig.teachersProfiles));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los profesores');
    }
  }

  Future<Teacher> getTeacherById(int id) async {
    final response = await http.get(Uri.parse('${ApiConfig.teachersProfiles}/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Teacher.fromJson(data);
    } else {
      throw Exception('Error al obtener el profesor');
    }
  }

  Future<void> createTeacher(Teacher teacher) async {
    final response = await http.post(
      Uri.parse(ApiConfig.teachersProfiles),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(teacher.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear el profesor');
    }
  }
}
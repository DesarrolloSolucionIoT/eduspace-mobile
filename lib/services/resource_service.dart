import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';
import '../models/resource.dart';
import '../utils/token_utils.dart';
import 'classroom_service.dart';

class ResourceService {
  /// Resources of a single classroom.
  Future<List<Resource>> getByClassroom(int classroomId) async {
    final headers = await getAuthHeaders();
    final response = await http.get(
      Uri.parse(ApiConfig.resourcesByClassroom(classroomId)),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((j) => _fromBackendJson(j as Map<String, dynamic>)).toList();
    }
    throw Exception('Error al obtener los recursos del aula $classroomId');
  }

  /// All resources across the logged-in teacher's classrooms.
  Future<List<Resource>> getMyResources() async {
    final teacherId = await getTeacherIdFromToken();
    final classrooms = await ClassroomService().getAllClassrooms();
    final mine = teacherId == null
        ? classrooms
        : classrooms.where((c) => c.teacherId == teacherId).toList();

    final result = <Resource>[];
    for (final c in mine) {
      if (c.id == null) continue;
      try {
        result.addAll(await getByClassroom(c.id!));
      } catch (_) {
        // Skip classrooms whose resources can't be fetched; don't fail the whole list.
      }
    }
    return result;
  }

  // Backend ResourceResource: { id, name, kindOfResource, classroom: { id, name, ... } }.
  // The mobile Resource model carries extra UI fields the backend doesn't have, so we
  // map sensibly: category <- kindOfResource, location <- classroom name.
  Resource _fromBackendJson(Map<String, dynamic> j) {
    final classroom = j['classroom'] as Map<String, dynamic>?;
    return Resource(
      id: j['id'] as int,
      name: j['name'] as String? ?? '',
      code: 'RES-${j['id']}',
      category: j['kindOfResource'] as String? ?? '',
      location: classroom?['name'] as String? ?? 'Sin aula',
      status: 'active',
    );
  }
}

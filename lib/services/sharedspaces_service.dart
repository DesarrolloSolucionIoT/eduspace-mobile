import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sharedspace.dart';
import '../config/ApiConfig.dart';
import '../utils/token_utils.dart';

class SharedSpacesService {
  Future<List<SharedSpace>> getAllSharedSpaces() async {
    final headers = await getAuthHeaders();

    final response = await http.get(Uri.parse(ApiConfig.sharedSpaces), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SharedSpace.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los espacios compartidos');
    }
  }

  Future<void> createSharedSpace(SharedSpace sharedSpace) async {
    final response = await http.post(
      Uri.parse(ApiConfig.sharedSpaces),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sharedSpace.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear el espacio compartido');
    }
  }


  // For reservations

  // Get reservations per date for a specific shared space
  Future<List<SharedSpaceReservation>> getReservations(int spaceId, DateTime date) async {
    final headers = await getAuthHeaders();
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    final response = await http.get(Uri.parse('${ApiConfig.sharedSpaces}/$spaceId/reservations?date=$dateString'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SharedSpaceReservation.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las reservas del espacio compartido');
    }
  }

  // Reserve a shared space
  Future<void> reserveSpace(int spaceId, int teacherId, DateTime date, String startTime, String endTime, String reason) async {
    final headers = await getAuthHeaders();
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final body = json.encode({
      'teacherId': teacherId,
      'reservationDate': dateString,
      'startTime': startTime,
      'endTime': endTime,
      'reason': reason
    });

    final response = await http.post(
      Uri.parse('${ApiConfig.sharedSpaces}/$spaceId/reserve'),
      headers: headers,
      body: body,
    );

    print('Reserve status: ${response.statusCode}, body: ${response.body}');

    if (response.statusCode == 409) throw Exception('El horario ya está reservado.');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al reservar el espacio compartido');
    }

  }

  // Get all reservations for a teacher
  Future<List<SharedSpaceReservation>> getTeacherReservations(int teacherId) async {
    final headers = await getAuthHeaders();

    final response = await http.get(Uri.parse('${ApiConfig.sharedSpaces}/teacher/$teacherId/reservations'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SharedSpaceReservation.fromJson(json)).toList();
    } else {
      print('Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Error al obtener las reservas del profesor');
    }
  }
}

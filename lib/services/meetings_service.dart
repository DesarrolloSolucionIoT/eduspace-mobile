import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';
import '../models/meeting.dart';

class MeetingsService {
  Future<List<Meeting>> getAllMeetings() async {
    final response = await http.get(Uri.parse(ApiConfig.meetings));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Meeting.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las reuniones');
    }
  }

  Future<void> createMeeting(Meeting meeting) async {
    // Construir la URL con los IDs
    final url = '${ApiConfig.baseUrl}/administrators/${meeting.administratorId}/classrooms/${meeting.classroomId}/meetings';

    // Solo los campos requeridos en el body
    final body = json.encode({
      'title': meeting.title,
      'description': meeting.description,
      'date': meeting.date,
      'start': meeting.start,
      'end': meeting.end,
    });

    print('POST $url body: $body');
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear la reunión');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';
import '../models/sensor_reading.dart';
import '../utils/token_utils.dart';

class IotService {
  /// Latest sensor reading for a zone. Returns null if the zone has no readings
  /// or if the API is unreachable.
  Future<SensorReading?> getLatestByZone(String zoneId) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .get(Uri.parse(ApiConfig.latestReadingByZone(zoneId)), headers: headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        return SensorReading.fromJson(json.decode(response.body) as Map<String, dynamic>);
      }
      return null; // 404 = zona sin lecturas
    } catch (_) {
      return null;
    }
  }

  /// All readings for a zone, ordered newest first.
  Future<List<SensorReading>> getReadingsByZone(String zoneId) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http
          .get(Uri.parse(ApiConfig.readingsByZone(zoneId)), headers: headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        return data.map((e) => SensorReading.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

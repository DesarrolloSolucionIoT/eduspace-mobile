import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';
import '../utils/token_utils.dart';

class ReportService {
  /// Creates a breakdown report for a real backend resource.
  /// Maps to the backend's CreateReportResource: { kindOfReport, description, resourceId, createdAt }.
  /// Throws with a user-friendly message on failure.
  Future<void> createReport({
    required String kindOfReport,
    required String description,
    required int resourceId,
  }) async {
    final headers = await getAuthHeaders();
    final body = json.encode({
      'kindOfReport': kindOfReport,
      'description': description,
      'resourceId': resourceId,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    });

    final response = await http.post(
      Uri.parse(ApiConfig.reports),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) return;
    if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Inicia sesión de nuevo.');
    }
    if (response.statusCode == 404) {
      throw Exception('El recurso ya no existe en el sistema.');
    }
    throw Exception('No se pudo enviar el reporte (error ${response.statusCode}).');
  }
}

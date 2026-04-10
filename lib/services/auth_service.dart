import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/ApiConfig.dart';
import '../models/administratorprofile.dart';

class AuthService {


  Future<Map<String, dynamic>?> signIn(String username, String password) async {
    try {
      debugPrint('Intentando iniciar sesión en: ${ApiConfig.signIn}');
      final response = await http.post(
        Uri.parse(ApiConfig.signIn),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      debugPrint('Respuesta de login: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error en signIn: $e');
      return null;
    }
  }

  static Future<AdministratorProfile> createAdminProfile(AdministratorProfile admin) async {
    final url = Uri.parse(ApiConfig.adminProfiles);
    final body = jsonEncode(admin.toJson());
    debugPrint('JSON a enviar: $body');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AdministratorProfile.fromJson(data);
    } else {
      throw Exception("Error al crear el administrador: ${response.body}");
    }
  }
}
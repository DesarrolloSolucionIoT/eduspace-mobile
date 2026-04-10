import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sharedspace.dart';
import '../config/ApiConfig.dart';

class SharedSpacesService {
  Future<List<SharedSpace>> getAllSharedSpaces() async {
    final response = await http.get(Uri.parse(ApiConfig.sharedSpaces));
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
}
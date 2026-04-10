import 'dart:convert';
import 'package:eduspace_mobile/models/administratorprofile.dart';
import 'package:http/http.dart' as http;
import '../config/ApiConfig.dart';

class AdminService {
  Future<AdministratorProfile?> getAdminById(int adminId) async {
    final url = '${ApiConfig.adminProfiles}/$adminId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return AdministratorProfile.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
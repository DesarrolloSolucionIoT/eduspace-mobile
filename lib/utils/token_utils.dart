import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<int?> getAdministratorIdFromToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null) return null;
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  final sid = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
  if (sid == null) return null;
  return int.tryParse(sid.toString());
}

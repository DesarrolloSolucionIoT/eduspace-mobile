import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// Claves de SharedPreferences
const String kAuthToken = 'auth_token';
const String kUserRole = 'user_role';
const String kProfileId = 'profile_id';

// Valores de rol que devuelve el backend (ERoles.ToString())
const String roleAdmin = 'RoleAdmin';
const String roleTeacher = 'RoleTeacher';

/// Rol almacenado tras el login ('RoleAdmin' | 'RoleTeacher').
Future<String?> getStoredRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(kUserRole);
}

/// ID del perfil (teacher o admin) almacenado tras el login.
/// El backend lo entrega como `profileId` en la respuesta de sign-in.
Future<int?> getStoredProfileId() async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getInt(kProfileId);
  if (stored != null) return stored;
  return _profileIdFromTokenFallback(prefs);
}

/// Fallback: intenta extraer el id del token si no se guardó el profileId.
int? _profileIdFromTokenFallback(SharedPreferences prefs) {
  final token = prefs.getString(kAuthToken);
  if (token == null) return null;
  final decoded = JwtDecoder.decode(token);
  final raw = decoded['sub'] ??
      decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
  if (raw == null) return null;
  return int.tryParse(raw.toString());
}

/// ID del docente (alias de profileId; usado por el flujo docente).
Future<int?> getTeacherIdFromToken() => getStoredProfileId();

/// ID del administrador (alias de profileId; usado por el flujo admin).
Future<int?> getAdministratorIdFromToken() => getStoredProfileId();

/// Headers HTTP con el JWT de autorización para llamadas a la Platform API.
Future<Map<String, String>> getAuthHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(kAuthToken);
  return {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}

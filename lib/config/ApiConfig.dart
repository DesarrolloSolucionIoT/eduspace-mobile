class ApiConfig {
  // Base URL for the API

static const String baseUrl = "https://eduspace-api.purplemushroom-1f6e5ae3.brazilsouth.azurecontainerapps.io/api/v1";



  //Deployed backend endpoints

  // Authentication endpoints (IAM)
  static const String signUp = '$baseUrl/authentication/sign-up';
  static const String signIn = '$baseUrl/authentication/sign-in';


  // Administrator profile endpoints
  static const String adminProfiles = '$baseUrl/administrator-profiles';

  // Teacher Profile endpoints
  static const String teachersProfiles = '$baseUrl/teachers-profiles';

  // Classroom endpoints
  static const String classrooms = '$baseUrl/classrooms';

  // Resource endpoints (scoped to a classroom)
  static String resourcesByClassroom(int classroomId) => '$classrooms/$classroomId/resources';

  // Breakdown report endpoints
  static const String reports = '$baseUrl/reports';

  // Shared Spaces endpoints
  static const String sharedSpaces = '$baseUrl/shared-area';

  // Meetings endpoints
  static const String meetings = '$baseUrl/meetings';

  // IoT Monitoring endpoints
  static const String sensorReadings = '$baseUrl/iot-monitoring/sensor-readings';
  static String latestReadingByZone(String zoneId) => '$sensorReadings/zone/$zoneId/latest';
  static String readingsByZone(String zoneId) => '$sensorReadings/zone/$zoneId';
}
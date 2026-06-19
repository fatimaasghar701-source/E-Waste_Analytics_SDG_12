class ApiConstants {
  // Base URL for your Flask API
  // 10.0.2.2 is the special IP for Android Emulator to access localhost
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  
  // Endpoints
  static const String predict = '/predict';
  static const String analytics = '/analytics';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

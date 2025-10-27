import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  // Read the --dart-define variable
  static const String _baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000', // Fallback for safety
  );

  ApiService(this.dio) {
    // Configure the Dio instance with our base URL
    dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(milliseconds: 5000), // 5 seconds
      receiveTimeout: const Duration(milliseconds: 3000), // 3 seconds
    );

    // You can add your interceptors here (like for the JWT token)
    // dio.interceptors.add(MyAuthInterceptor());
  }

  /// --- Health Check ---
  ///
  /// Calls your NestJS backend's /health endpoint.
  /// Returns 'true' if the server responds with 200 OK.
  Future<bool> checkHealth() async {
    try {
      // This will make a GET request to:
      // $BASE_URL/health
      final response = await dio.get('/health');

      // Return true if the status code is 200-299
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
          
    } on DioException catch (e) {
      // Handle all Dio errors (timeout, no connection, 404, 500)
      print("Health check failed: $e");
      return false;
    } catch (e) {
      // Handle any other programming errors
      print("An unexpected error occurred: $e");
      return false;
    }
  }

  // --- Other Methods ---

  // You would add all your other methods here:
  
  // Future<List<SavedVerse>> fetchSavedVerses() async { ... }
  // Future<User> fetchUserStats() async { ... }
  // Future<void> postNewVerse(SavedVerse verse) async { ... }
}
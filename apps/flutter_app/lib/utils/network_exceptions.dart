class OfflineException implements Exception {
  final String message = "No internet connection.";
}

class ServerDownException implements Exception {
  final String message = "Server is currently unreachable.";
}
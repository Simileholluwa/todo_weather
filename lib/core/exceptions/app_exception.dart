class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([super.message = "No Internet Connection"]);
}

class ApiException extends AppException {
  ApiException([super.message = "Something went wrong with the API"]);
}

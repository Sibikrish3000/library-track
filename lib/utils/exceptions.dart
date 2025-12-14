class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CacheException extends AppException {
  CacheException([super.message = 'Cache error occurred']);
}

class ValidationException extends AppException {
  ValidationException([super.message = 'Validation error occurred']);
}

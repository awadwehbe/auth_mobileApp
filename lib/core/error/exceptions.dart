// exceptions.dart

// Base class for all custom exceptions
class AppException implements Exception {
  final String message;
  final String? prefix;
  final int? statusCode;

  AppException(this.message, {this.prefix, this.statusCode});

  @override
  String toString() {
    return "${prefix ?? 'Error'}: $message";
  }
}

// Common exceptions used in API fetching and general app operations

// Handles network-related errors (e.g., no internet, server down)
class NetworkException extends AppException {
  NetworkException({String message = "Network error occurred"})
      : super(message, prefix: "Network Error");
}

// Handles timeout issues (e.g., server taking too long to respond)
class TimeoutException extends AppException {
  TimeoutException({String message = "Request timed out"})
      : super(message, prefix: "Timeout Error");
}

// Handles unauthorized errors (e.g., invalid token, session expired)
class AuthException extends AppException {
  AuthException({String message = "Unauthorized access", int? statusCode})
      : super(message, prefix: "Authorization Error", statusCode: statusCode);
}

// Handles API response errors (e.g., bad request, not found, internal server error)
class ApiException extends AppException {
  ApiException({String message = "API error occurred", int? statusCode})
      : super(message, prefix: "API Error", statusCode: statusCode);
}

// Handles general bad request (e.g., invalid input from the client)
class BadRequestException extends AppException {
  BadRequestException({String message = "Bad request", int? statusCode})
      : super(message, prefix: "Bad Request", statusCode: statusCode);
}

// Handles server-side errors (e.g., internal server error)
class ServerException extends AppException {
  ServerException({String message = "Server error occurred", int? statusCode})
      : super(message, prefix: "Server Error", statusCode: statusCode);
}


// This will handle cache-related exceptions (e.g., cache miss or read/write failure)
class CacheException extends AppException {
  CacheException({String message = "Cache error"})
      : super(message, prefix: "Cache Error");
}

// Business Logic Layer Exceptions
class BusinessLogicException extends AppException {
  BusinessLogicException({String message = "Business rule violation"})
      : super(message, prefix: "Business Logic Error");
}

// UI Layer Exceptions
class UIException extends AppException {
  UIException({String message = "UI rendering error occurred"})
      : super(message, prefix: "UI Error");
}

// General exceptions for unknown or uncategorized errors
class GeneralException extends AppException {
  GeneralException({String message = "An unknown error occurred"})
      : super(message, prefix: "Error");
}
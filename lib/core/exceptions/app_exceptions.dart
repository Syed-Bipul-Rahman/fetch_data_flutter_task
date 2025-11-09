/// Base exception class for all application exceptions.
///
/// All custom exceptions in the app should extend this class to provide
/// consistent error handling and better debugging information.
///
/// **Properties:**
/// - [message]: A user-friendly error message
/// - [details]: Optional technical details for debugging
///
/// **Usage:**
/// ```dart
/// try {
///   // Some operation
/// } on NoInternetException catch (e) {
///   print('Offline: ${e.message}');
/// } on ServerException catch (e) {
///   print('Server error (${e.statusCode}): ${e.message}');
/// }
/// ```
abstract class AppException implements Exception {
  /// User-friendly error message
  final String message;

  /// Optional technical details for debugging
  final String? details;

  /// Creates an [AppException] with a [message] and optional [details].
  AppException(this.message, [this.details]);

  @override
  String toString() {
    if (details != null) {
      return '$message: $details';
    }
    return message;
  }
}

/// Exception thrown when there is no internet connection.
///
/// This exception indicates that the device is offline or cannot reach
/// the server due to network connectivity issues.
///
/// **When to use:**
/// - Device is in airplane mode
/// - WiFi/cellular data is disabled
/// - Network socket errors occur
///
/// **Example:**
/// ```dart
/// if (!await connectivity.checkConnectivity()) {
///   throw NoInternetException();
/// }
/// ```
class NoInternetException extends AppException {
  NoInternetException([String? details])
      : super('No internet connection', details);
}

/// Exception thrown when an API request times out.
///
/// This occurs when the server takes too long to respond, typically due to:
/// - Slow network connection
/// - Server overload
/// - Large data transfers
///
/// **Default timeout:** 30 seconds (configured in ApiService)
///
/// **Example:**
/// ```dart
/// try {
///   await apiService.get('/data');
/// } on TimeoutException {
///   // Show retry option to user
/// }
/// ```
class TimeoutException extends AppException {
  TimeoutException([String? details])
      : super('Request timeout', details);
}

/// Exception thrown when the server returns an error response.
///
/// This exception includes the HTTP status code for more specific error handling.
///
/// **Common status codes:**
/// - 400: Bad Request
/// - 401: Unauthorized
/// - 403: Forbidden
/// - 404: Not Found
/// - 500: Internal Server Error
/// - 503: Service Unavailable
///
/// **Example:**
/// ```dart
/// try {
///   await apiService.get('/users/123');
/// } on ServerException catch (e) {
///   if (e.statusCode == 404) {
///     print('User not found');
///   } else if (e.statusCode == 500) {
///     print('Server error, try again later');
///   }
/// }
/// ```
class ServerException extends AppException {
  /// HTTP status code (e.g., 404, 500)
  final int? statusCode;

  /// Creates a [ServerException] with a [message], optional [statusCode], and [details].
  ServerException(super.message, [this.statusCode, super.details]);

  @override
  String toString() {
    if (statusCode != null) {
      return 'ServerException ($statusCode): $message${details != null ? ' - $details' : ''}';
    }
    return super.toString();
  }
}

/// Exception thrown when JSON/data parsing fails.
///
/// This occurs when:
/// - API response format doesn't match expected structure
/// - Required fields are missing in the response
/// - Data types don't match model definitions
///
/// **Example:**
/// ```dart
/// try {
///   final data = json.decode(response);
///   return Model.fromJson(data);
/// } catch (e) {
///   throw ParsingException('Invalid model structure: $e');
/// }
/// ```
class ParsingException extends AppException {
  ParsingException([String? details])
      : super('Failed to parse data', details);
}

/// Exception thrown when cache operations fail.
///
/// This can occur when:
/// - Cache storage is full
/// - Cache service is not initialized
/// - Data corruption in cache
///
/// **Example:**
/// ```dart
/// try {
///   await cacheService.put('key', data);
/// } on CacheException catch (e) {
///   // Log error and continue without caching
///   print('Cache write failed: ${e.message}');
/// }
/// ```
class CacheException extends AppException {
  CacheException([String? details])
      : super('Cache operation failed', details);
}

/// Exception thrown when requested data is not found.
///
/// This is different from [ServerException] with 404 status, as it can also
/// indicate missing data in local storage or cache.
///
/// **Example:**
/// ```dart
/// final user = cache.get('user_123');
/// if (user == null) {
///   throw NotFoundException('User not found in cache');
/// }
/// ```
class NotFoundException extends AppException {
  NotFoundException([String? details])
      : super('Data not found', details);
}

/// Exception thrown for unexpected or unknown errors.
///
/// This is a catch-all exception for errors that don't fit other categories.
/// Should be used sparingly - prefer specific exception types when possible.
///
/// **Example:**
/// ```dart
/// try {
///   // Complex operation
/// } on AppException {
///   rethrow;
/// } catch (e) {
///   throw UnknownException('Unexpected error: $e');
/// }
/// ```
class UnknownException extends AppException {
  UnknownException([String? details])
      : super('An unknown error occurred', details);
}

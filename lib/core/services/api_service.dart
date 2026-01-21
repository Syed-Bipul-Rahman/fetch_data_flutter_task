import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.headers,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Add interceptors for logging (only in debug mode)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Request logging
          assert(() {
            if (kDebugMode) {
              print('REQUEST[${options.method}] => PATH: ${options.path}');
            }
            return true;
          }());
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Response logging
          assert(() {
            if (kDebugMode) {
              print(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
              );
            }
            return true;
          }());
          return handler.next(response);
        },
        onError: (error, handler) {
          // Error logging
          assert(() {
            if (kDebugMode) {
              print(
                'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
              );
            }
            return true;
          }());
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Sends a POST request to the specified [path].
  ///
  /// Used for creating new resources on the server.
  ///
  /// **Parameters:**
  /// - [path]: API endpoint path
  /// - [data]: Request body data (can be Map, FormData, etc.)
  /// - [queryParameters]: Optional URL query parameters
  /// - [options]: Optional request configuration
  /// - [cancelToken]: Optional token to cancel the request
  ///
  /// **Example:**
  /// ```dart
  /// final response = await apiService.post(
  ///   '/users',
  ///   data: {'name': 'John', 'email': 'john@example.com'},
  /// );
  /// ```
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Sends a PUT request to the specified [path].
  ///
  /// Used for completely replacing an existing resource on the server.
  ///
  /// **Parameters:**
  /// - [path]: API endpoint path
  /// - [data]: Complete resource data to replace existing resource
  /// - [queryParameters]: Optional URL query parameters
  /// - [options]: Optional request configuration
  /// - [cancelToken]: Optional token to cancel the request
  ///
  /// **Example:**
  /// ```dart
  /// final response = await apiService.put(
  ///   '/users/123',
  ///   data: {'name': 'John Doe', 'email': 'john@example.com', 'age': 30},
  /// );
  /// ```
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Sends a PATCH request to the specified [path].
  ///
  /// Used for partially updating an existing resource on the server.
  ///
  /// **Parameters:**
  /// - [path]: API endpoint path
  /// - [data]: Partial resource data containing only fields to update
  /// - [queryParameters]: Optional URL query parameters
  /// - [options]: Optional request configuration
  /// - [cancelToken]: Optional token to cancel the request
  ///
  /// **Example:**
  /// ```dart
  /// final response = await apiService.patch(
  ///   '/users/123',
  ///   data: {'email': 'newemail@example.com'}, // Only updating email
  /// );
  /// ```
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Sends a DELETE request to the specified [path].
  ///
  /// Used for deleting an existing resource from the server.
  ///
  /// **Parameters:**
  /// - [path]: API endpoint path
  /// - [data]: Optional request body data
  /// - [queryParameters]: Optional URL query parameters
  /// - [options]: Optional request configuration
  /// - [cancelToken]: Optional token to cancel the request
  ///
  /// **Example:**
  /// ```dart
  /// final response = await apiService.delete('/users/123');
  /// ```
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Converts DioException to typed AppException for better error handling.
  ///
  /// This method maps Dio's generic exceptions to our custom exception types,
  /// allowing for more specific error handling in the UI layer.
  ///
  /// **Mapping:**
  /// - Connection/Send/Receive Timeout → [TimeoutException]
  /// - Connection Error → [NoInternetException]
  /// - Bad Response (4xx, 5xx) → [ServerException]
  /// - Request Cancelled → [UnknownException]
  /// - Bad Certificate → [ServerException]
  /// - Socket Exception → [NoInternetException]
  /// - Other Unknown Errors → [UnknownException]
  ///
  /// **Example:**
  /// ```dart
  /// try {
  ///   await dio.get('/api/data');
  /// } on DioException catch (e) {
  ///   throw _handleDioError(e); // Converts to typed exception
  /// }
  /// ```
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(error.message);

      case DioExceptionType.connectionError:
        return NoInternetException(error.message);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.statusMessage ?? 'Server error';
        return ServerException(message, statusCode, error.message);

      case DioExceptionType.cancel:
        return UnknownException('Request cancelled');

      case DioExceptionType.badCertificate:
        return ServerException('Bad certificate', null, error.message);

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NoInternetException(error.message);
        }
        return UnknownException(error.message);
    }
  }

  void dispose() {
    _dio.close();
  }
}

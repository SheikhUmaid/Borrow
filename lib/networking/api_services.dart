import 'package:borrow/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: apiurl, // Change to your base URL
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ) {
    // Add interceptors for logging and error handling if needed
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
    // You can add more interceptors here (e.g., authentication, caching)
  }

  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      // Set additional headers if provided.
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }

      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      // Handle errors appropriately (you might want to log or rethrow custom exceptions)
      throw Exception(_handleDioError(e));
    }
  }

  Future<Response> postRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      if (headers != null) {
        _dio.options.headers.addAll(headers);
      }

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      throw Exception((e));
    }
  }

  /// Converts DioError into a user-friendly error message.
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return "Request was cancelled";
      // case DioExceptionType.connectionTimeout:
      //   return "Connection timeout with API server";
      // case DioExceptionType.sendTimeout:
      //   return "Send timeout in connection with API server";
      // case DioExceptionType.receiveTimeout:
      //   return "Receive timeout in connection with API server";
      // case DioExceptionType.badResponse:
      //   return "Received invalid status code: ${error.response?.statusCode}";
      // case DioExceptionType.unknown:
      default:
        return "Connection to API server failed due to internet connection";
    }
  }
}

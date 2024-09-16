import 'dart:convert';
import 'package:auth_app/core/network/response_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../hive.dart';
import '../error/exceptions.dart';


class ApiClient {
  static final Dio _dio = Dio();
  static bool enableNetworkLogs = true;
  static Logger logger = Logger();

  /// Initializes Dio with default configurations (base options like headers)
  static void initDio() {
    _dio.options = BaseOptions(
      baseUrl: "https://my-notes-app-apis.onrender.com/api", // Base URL for API
      connectTimeout: const Duration(seconds: 5), // Timeout in seconds
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'en', // Replace with dynamic locale if needed
      },
    );

    // Add interceptors for token handling and logging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Retrieve access token from Hive storage
        String? accessToken = await SharedPrefsManager.getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        logger.i("Request: ${options.uri}, Headers: ${options.headers}");
        return handler.next(options); // Proceed with the request
      },
      onResponse: (response, handler) {
        logger.i("Response: ${response.data}");
        return handler.next(response); // Proceed with the response
      },
      onError: (error, handler) {
        logger.e("Error: $error");
        return handler.next(error); // Proceed with the error handling
      },
    ));

    // Enable logging
    if (enableNetworkLogs) {
      _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
  }

  /// Refreshes the access token by sending the refresh token in the Authorization header
  static Future<bool> refreshAccessToken() async {
    String? refreshToken = await SharedPrefsManager.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false; // No refresh token available
    }

    try {
      final response = await _dio.post(
        "/auth/refresh-token",
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      ResponseModel responseModel = ResponseModel.fromJson(response.data);
      if (responseModel.statusCode == 200) {
        await SharedPrefsManager.saveAccessToken(responseModel.data['access_token']);
        await SharedPrefsManager.saveRefreshToken(responseModel.data['refresh_token']);
        return true; // Token refreshed successfully
      } else {
        throw AuthException(message: 'Failed to refresh token');
      }
    } catch (e) {
      logger.e('Error refreshing token: $e');
      throw ApiException(message: 'Error refreshing token');
    }
  }

  /// Generic method for handling API requests (GET, POST, PUT, DELETE)
  static Future<ResponseModel> request({
    required String url,
    required String method,
    dynamic data,
    bool withToken = true,
  }) async {
    try {
      final response = await _makeRequest(url: url, method: method, data: data);
      return response;
    } on DioException catch (error) {
      return _handleDioError(error, withToken, url, method, data);
    } catch (e) {
      throw GeneralException(message: 'An unknown error occurred');
    }
  }

  /// Private method to handle API request
  static Future<ResponseModel> _makeRequest({
    required String url,
    required String method,
    dynamic data,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: data != null ? jsonEncode(data) : null,
        options: Options(method: method),
      );

      return _handleResponse(response);
    } catch (error) {
      logger.e('Error during request: $error');
      throw GeneralException(message: 'Failed to process the request');
    }
  }

  /// Handles DioError and maps it to appropriate AppException
  static Future<ResponseModel> _handleDioError(
      DioException error,
      bool withToken,
      String url,
      String method,
      dynamic data,
      ) async {
    // Check for network errors
    if (error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout) {
      throw TimeoutException(message: 'Connection timeout');
    }

    // Handle response error status codes
    final statusCode = error.response?.statusCode;
    if (statusCode == 400) {
      throw BadRequestException(message: 'Invalid request data', statusCode: statusCode);
    } else if (statusCode == 401 && withToken) {
      // Try to refresh token on unauthorized error
      bool tokenRefreshed = await refreshAccessToken();
      if (tokenRefreshed) {
        return await _makeRequest(url: url, method: method, data: data);
      } else {
        throw AuthException(message: 'Session expired. Please log in again', statusCode: 401);
      }
    } else if (statusCode == 403) {
      throw AuthException(message: 'Unauthorized access', statusCode: statusCode);
    } else if (statusCode == 404) {
      throw ApiException(message: 'Requested resource not found', statusCode: statusCode);
    } else if (statusCode == 500) {
      throw ServerException(message: 'Internal server error', statusCode: statusCode);
    }

    throw ApiException(message: 'An API error occurred', statusCode: statusCode);
  }

  /// Handles and parses API responses into a ResponseModel
  static ResponseModel _handleResponse(Response response) {
    final data = response.data;
    return ResponseModel(
      statusCode: data['statusCode'],
      message: data['message'],
      data: data['data'],
    );
  }
}

import 'dart:convert';
import 'package:auth_app/core/network/response_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../hive.dart';


/// API Client service for network requests using Dio and Hive-based SharedPrefsManager
class ApiClient {
  static Dio _dio = Dio();
  static bool enableNetworkLogs = true;
  static Logger logger = Logger();

  /// Initializes Dio with default configurations (base options like headers)
  static void initDio() {
    _dio.options = BaseOptions(
      baseUrl: "https://api.yourapp.com", // Base URL for API
      connectTimeout:Duration(seconds: 5000) , // Timeout in milliseconds
      receiveTimeout: Duration(seconds: 3000),
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

        // If there is an access token, add it to the headers
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
    // Retrieve refresh token from Hive storage
    String? refreshToken = await SharedPrefsManager.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false; // No refresh token available, cannot refresh
    }

    try {
      final response = await _dio.post(
        "/auth/refresh-token",
        options: Options(headers: {
          'Authorization': 'Bearer $refreshToken', // Send the refresh token in the Authorization header
        }),
      );

      ResponseModel responseModel = ResponseModel.fromJson(response.data);

      if (responseModel.statusCode == 200) {
        // Save new tokens in Hive
        await SharedPrefsManager.saveAccessToken(responseModel.data['access_token']);
        await SharedPrefsManager.saveRefreshToken(responseModel.data['refresh_token']);
        return true; // Token refreshed successfully
      } else {
        logger.e('Failed to refresh token: ${responseModel.message}');
        return false; // Token refresh failed
      }
    } catch (e) {
      logger.e('Error refreshing token: $e');
      return false; // Token refresh failed due to an error
    }
  }

  /// Generic method for handling API requests (GET, POST, PUT, DELETE)
  static Future<ResponseModel> request({
    required String url,
    required String method, // "GET", "POST", "PUT", "DELETE"
    dynamic data,
    bool withToken = true, // Controls whether token injection is required
  }) async {
    try {
      // First attempt to make the request
      final response = await _makeRequest(url: url, method: method, data: data);
      return response;
    } on DioError catch (error) {
      // If token is expired (401 Unauthorized), attempt to refresh token
      if (error.response?.statusCode == 401 && withToken) {
        bool tokenRefreshed = await refreshAccessToken();
        if (tokenRefreshed) {
          // Retry the original request with the refreshed token
          return await _makeRequest(url: url, method: method, data: data);
        } else {
          return ResponseModel(
            statusCode: 401,
            message: 'Session expired. Please login again.',
          );
        }
      } else {
        return ResponseModel(statusCode: 500, message: 'Something went wrong');
      }
    }
  }

  /// Private method to perform the actual network request
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

      // Handle and parse response
      return _handleResponse(response);
    } catch (e) {
      logger.e(e);
      throw DioError(requestOptions: RequestOptions(path: url)); // Re-throw to handle error
    }
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
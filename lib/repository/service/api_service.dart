import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:audionyx/repository/service/auth_service/auth_interceptor.dart';
import 'package:audionyx/core/constants/app_strings.dart';

class ApiService {
  late Dio _dio;
  final GlobalKey<NavigatorState> navigatorKey;

  ApiService(this.navigatorKey) {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppStrings.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    // Add auth interceptor to handle token expiration
    _dio.interceptors.add(AuthInterceptor(_dio, navigatorKey));

    // Add logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // Handle errors
  void _handleError(DioException e) {
    debugPrint('API Error: ${e.message}');
    // The AuthInterceptor will handle 401 errors
  }
}

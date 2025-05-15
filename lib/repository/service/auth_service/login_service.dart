import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../api_service.dart';

class LoginService {
  final ApiService _apiService;

  LoginService(GlobalKey<NavigatorState> navigatorKey)
    : _apiService = ApiService(navigatorKey);

  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    try {
      final response = await _apiService.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'];
        await AppStrings.secureStorage.write(key: 'jwt_token', value: token);
        return token;
      } else {
        throw Exception(response.data['msg'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['msg'] ?? 'Login failed: ${e.message}');
    }
  }

  Future<void> logout() async {
    await AppStrings.secureStorage.delete(key: 'jwt_token');
  }

  Future<String> fetchProtectedData(String apiPath) async {
    try {
      final response = await _apiService.get(apiPath);

      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw Exception('Failed to fetch data: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch data: ${e.message}');
    }
  }
}

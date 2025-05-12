// registration_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:audionyx/repository/service/api_service.dart';

import '../../../main.dart'; // Adjust import path as needed

class RegistrationService {
  final ApiService _apiService = ApiService(navigatorKey);


  Future<String> registerUser({
    required String name,
    required String email,
    String? password,
    String? googleIdToken,
    bool isGoogleAuth = false,
  }) async {
    // Dynamically set the endpoint based on isGoogleAuth
    final String endpoint = isGoogleAuth ? 'auth/google' : 'auth/register';

    debugPrint('Sending registration to $endpoint');
    debugPrint('Data: {user_name: $name, email: $email, isGoogleAuth: $isGoogleAuth}');

    try {
      // Prepare registration data
      final Map<String, dynamic> registrationData = {
        'user_name': name,
        'email': email,
        'is_google_auth': isGoogleAuth,
      };

      // Add conditional fields
      if (password != null && !isGoogleAuth) {
        registrationData['password'] = password;
      }

      if (googleIdToken != null && isGoogleAuth) {
        registrationData['google_id_token'] = googleIdToken;
      }

      // Use the ApiService to make the request
      final response = await _apiService.post(
        endpoint,
        data: registrationData,
      );

      debugPrint('Response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 201) {
        return response.data['msg'] ?? 'User registered successfully';
      } else {
        throw Exception('Failed to register: ${response.data['msg'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('DioError: type=${e.type}, message=${e.message}, response=${e.response}');
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data['msg'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Registration error: $e');
    }
  }
}
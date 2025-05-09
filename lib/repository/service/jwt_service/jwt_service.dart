import 'dart:convert';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:audionyx/core/constants/app_strings.dart';

class JwtService {
  // Singleton pattern
  static final JwtService _instance = JwtService._internal();

  factory JwtService() => _instance;

  JwtService._internal();

  // Check if token exists and is valid
  Future<bool> isTokenValid() async {
    final token = await AppStrings.secureStorage.read(key: 'jwt_token');

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      // Check if token is expired
      if (JwtDecoder.isExpired(token)) {
        // Token expired, clear it
        await AppStrings.secureStorage.delete(key: 'jwt_token');
        return false;
      }

      return true;
    } catch (e) {
      // Invalid token format
      await AppStrings.secureStorage.delete(key: 'jwt_token');
      return false;
    }
  }

  // Get token expiration time
  Future<DateTime?> getTokenExpiryDate() async {
    try {
      final token = await AppStrings.secureStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return null;

      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  // Get token payload
  Future<Map<String, dynamic>?> getTokenPayload() async {
    try {
      final token = await AppStrings.secureStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return null;

      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  // Handle expired token (clear token and navigate to login)
  void handleExpiredToken(BuildContext context) {
    AppStrings.secureStorage.delete(key: 'jwt_token');

    // Using the extension method from extension.dart
    context.pushAndRemoveUntil(context, target: const LoginScreen());
  }
}

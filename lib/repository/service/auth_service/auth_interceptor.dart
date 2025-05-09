import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:audionyx/core/constants/app_strings.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthInterceptor(this.dio, this.navigatorKey);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add JWT token to request if available
    final token = await AppStrings.secureStorage.read(key: 'jwt_token');

    if (token != null && token.isNotEmpty) {
      // Check if token is expired before making the request
      if (JwtDecoder.isExpired(token)) {
        // Token is expired, redirect to login
        _redirectToLogin();

        // Complete the interceptor with an error
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'JWT token expired',
            type: DioExceptionType.unknown,
          ),
        );
      }

      // Token is valid, add it to headers
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check for 401 Unauthorized response (token expired or invalid)
    if (err.response?.statusCode == 401) {
      _redirectToLogin();
    }

    return handler.next(err);
  }

  void _redirectToLogin() async {
    // Clear token
    await AppStrings.secureStorage.delete(key: 'jwt_token');

    // Use the navigator key to navigate to login screen from anywhere
    if (navigatorKey.currentContext != null) {
      // Import here to avoid circular dependency
      // Using named route to avoid import issues
       navigatorKey.currentContext?.pushAndRemoveUntil(navigatorKey.currentContext!, target: LoginScreen());
    }
  }
}
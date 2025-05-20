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
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      debugPrint('Reading JWT token...');
      final token = await AppStrings.secureStorage.read(key: 'jwt_token');
      debugPrint('Token: $token');

      if (token != null && token.isNotEmpty) {
        // Check if token is expired before making the request
        if (JwtDecoder.isExpired(token)) {
          debugPrint('JWT token expired, redirecting to login');
          _redirectToLogin();
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'JWT token expired',
              type: DioExceptionType.unknown,
            ),
          );
        }

        // Token is valid, add it to headers
        debugPrint('Adding Bearer token to headers');
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        debugPrint('No JWT token found');
      }
    } catch (e) {
      debugPrint('Error reading JWT token: $e');
      _redirectToLogin();
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to read JWT token: $e',
          type: DioExceptionType.unknown,
        ),
      );
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('Dio error: ${err.message}, Status: ${err.response?.statusCode}');
    // Check for 401 Unauthorized response (token expired or invalid)
    if (err.response?.statusCode == 401) {
      debugPrint('Received 401, redirecting to login');
      _redirectToLogin();
    }

    return handler.next(err);
  }

  void _redirectToLogin() async {
    debugPrint('Clearing JWT token and redirecting to LoginScreen');
    try {
      await AppStrings.secureStorage.delete(key: 'jwt_token');
    } catch (e) {
      debugPrint('Error deleting JWT token: $e');
    }

    final context = navigatorKey.currentContext;
    if (context != null) {
      context.pushAndRemoveUntil(context, target: LoginScreen());
    } else {
      debugPrint('Navigator context is null, cannot redirect');
    }
  }
}

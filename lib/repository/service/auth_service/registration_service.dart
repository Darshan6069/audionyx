import 'package:audionyx/core/constants/app_strings.dart';
import 'package:dio/dio.dart';

class RegistrationService {
  final Dio dio = Dio();

  Future<String> registerUser({
    required String name,
    required String email,
    String? password,
    String? googleIdToken,
    bool isGoogleAuth = false,
  }) async {
    // Dynamically set the endpoint based on isGoogleAuth
    final String endpoint = isGoogleAuth ? 'auth/google' : 'auth/register';
    final String url = '${AppStrings.baseUrl}$endpoint';

    print('Sending registration to $url');
    print('Data: {user_name: $name, email: $email, isGoogleAuth: $isGoogleAuth}');
    try {
      final response = await dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'user_name': name,
          'email': email,
          if (password != null && !isGoogleAuth) 'password': password,
          if (googleIdToken != null && isGoogleAuth) 'google_id_token': googleIdToken,
          'is_google_auth': isGoogleAuth,
        },
      );
      print('Response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 201) {
        return response.data['msg'] ?? 'User registered successfully';
      } else {
        throw Exception('Failed to register: ${response.data['msg'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioError: type=${e.type}, message=${e.message}, response=${e.response}');
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data['msg'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Registration error: $e');
    }
  }
}
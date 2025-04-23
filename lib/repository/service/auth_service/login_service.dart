import 'package:dio/dio.dart';

import '../../../core/constants/app_strings.dart';

class LoginService {
  final Dio dio = Dio();
  final String loginUrl = '${AppStrings.baseUrl}auth/login'; // Replace this with your real URL

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    final response = await dio.post(
      loginUrl,
      options: Options(headers: {
        'Content-Type': 'application/json',
      }),
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final token = response.data['token'];
      await AppStrings.secureStorage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception(response.data['msg'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await AppStrings.secureStorage.delete(key: 'jwt_token');
  }

  Future<String> fetchProtectedData(String apiUrl) async {
    final token = await AppStrings.secureStorage.read(key: 'jwt_token');
    if (token == null) throw Exception('No token found. Please log in again.');

    final response = await dio.get(
      apiUrl,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      return response.data.toString();
    } else {
      throw Exception('Failed to fetch data: ${response.data}');
    }
  }



}

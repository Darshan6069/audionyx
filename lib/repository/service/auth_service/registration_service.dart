import 'package:audionyx/core/constants/app_strings.dart';
import 'package:dio/dio.dart';

class RegistrationService {
  final Dio dio = Dio();
  final String baseUrl = '${AppStrings.baseUrl}auth/register'; // Replace this with your real URL

  Future<String> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        baseUrl,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        return 'User registered successfully';
      } else {
        throw Exception('Failed to register: ${response.data}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
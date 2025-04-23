import 'package:audionyx/core/constants/app_strings.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final Dio dio = Dio();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        print('User canceled Google sign-in');
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        print('Failed to get idToken');
        return;
      }

      final response = await dio.post(
        '${AppStrings.baseUrl}auth/google', // replace with your actual backend URL
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'token': idToken},
      );

      print('Response: ${response.data}');
    } catch (e) {
      print('Google sign-in failed: $e');
    }
  }
}

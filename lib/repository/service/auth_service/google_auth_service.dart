import 'package:google_sign_in/google_sign_in.dart';
import 'package:audionyx/repository/service/auth_service/registration_service.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_GOOGLE_CLIENT_ID', // Replace with your OAuth Client ID
    scopes: ['email', 'profile'],
  );
  final RegistrationService _registrationService = RegistrationService();

  Future<Map<String, String>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In canceled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      print('Google Sign-In successful: ${googleUser.displayName}, ${googleUser.email}');
      print('ID Token: $idToken');

      // Register user in MongoDB via backend
      final message = await _registrationService.registerUser(
        name: googleUser.displayName ?? 'Unknown',
        email: googleUser.email,
        googleIdToken: idToken,
        isGoogleAuth: true,
      );

      return {
        'message': message,
        'email': googleUser.email,
        'name': googleUser.displayName ?? 'Unknown',
      };
    } catch (e) {
      print('Google Sign-In error: $e');
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
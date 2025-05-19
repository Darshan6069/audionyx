import 'package:google_sign_in/google_sign_in.dart';
import 'package:audionyx/repository/service/auth_service/registration_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '815538582382-4fkhe4kd3mk63k7oofs96pj75noaq2vt.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );
  final RegistrationService _registrationService = RegistrationService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In canceled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      debugPrint(
        'Google Sign-In successful: ${googleUser.displayName}, ${googleUser.email}',
      );

      // Register user in MongoDB via backend and get JWT token
      final jwtToken = await _registrationService.registerUser(
        name: googleUser.displayName ?? 'Unknown',
        email: googleUser.email,
        googleIdToken: idToken,
        isGoogleAuth: true,
      );

      // Save JWT token to secure storage and log for debugging
      debugPrint('Saving JWT token to secure storage');
      await _storage.write(key: 'jwt_token', value: jwtToken);

      // Verify token was saved correctly
      final savedToken = await _storage.read(key: 'jwt_token');
      debugPrint(
        'Verified saved token: ${savedToken != null ? 'Present' : 'Missing'}',
      );

      if (savedToken != null) {
        debugPrint('Token length: ${savedToken.length}');
        debugPrint(
          'Token starts with: ${savedToken.substring(0, savedToken.length > 10 ? 10 : savedToken.length)}...',
        );
      }

      return {
        'token': jwtToken,
        'email': googleUser.email,
        'name': googleUser.displayName ?? 'Unknown',
      };
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _storage.delete(key: 'jwt_token');
    debugPrint('User signed out, token deleted');
  }
}

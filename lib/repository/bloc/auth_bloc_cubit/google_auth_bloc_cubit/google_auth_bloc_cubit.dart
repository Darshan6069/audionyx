import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import 'package:audionyx/repository/service/auth_service/google_auth_service.dart';

class GoogleLoginBlocCubit extends Cubit<LoginState> {
  final GoogleAuthService _googleAuthService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  GoogleLoginBlocCubit(this._googleAuthService)
    : super(const LoginState.initial());

  Future<void> signInWithGoogle() async {
    emit(const LoginState.loading());

    try {
      final result = await _googleAuthService.signInWithGoogle();
      if (result == null) {
        emit(const LoginState.failure("Google Sign-In canceled"));
        return;
      }

      final email = result['email'] ?? '';
      final name = result['name'] ?? 'Unknown';
      // Assuming the backend returns a JWT token in the message or another field
      // Adjust based on actual backend response
      final token =
          result['message'] ??
          ''; // Replace with actual token field if different
      final userId =
          email; // Use email as userId or adjust based on backend response

      await _storage.write(key: 'jwt_token', value: token);
      await _storage.write(key: 'userId', value: userId);

      emit(LoginState.success(token, userId));
    } catch (e) {
      emit(LoginState.failure(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _googleAuthService.signOut();
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'userId');
    emit(const LoginState.initial());
  }
}

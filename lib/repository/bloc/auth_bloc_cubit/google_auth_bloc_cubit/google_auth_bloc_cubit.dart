import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import 'package:audionyx/repository/service/auth_service/google_auth_service.dart';

class GoogleLoginBlocCubit extends Cubit<LoginState> {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  GoogleLoginBlocCubit() : super(const LoginState.initial());

  Future<void> signInWithGoogle() async {
    emit(const LoginState.loading());

    try {
      final result = await _googleAuthService.signInWithGoogle();
      if (result == null) {
        emit(const LoginState.failure("You canceled the Google Sign-In process"));
        return;
      }

      final email = result['email'] ?? '';
      final name = result['name'] ?? 'Unknown';
      final token = result['token'] ?? '';
      final userId = result['userId'] ?? email;

      await _storage.write(key: 'jwt_token', value: token);
      await _storage.write(key: 'userId', value: userId);
      await _storage.write(key: 'authType', value: 'google'); // Store auth type

      emit(LoginState.success(token, userId));
    } catch (e) {
      emit(LoginState.failure(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _googleAuthService.signOut();
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'authType'); // Clear auth type
    emit(const LoginState.initial());
  }
}

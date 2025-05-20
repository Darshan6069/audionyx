import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../main.dart';
import '../../../service/auth_service/login_service.dart';
import '../../../service/song_service/favorite_song_service/favorite_song_service.dart';
import '../../../service/song_service/recently_play_song/recently_played_manager.dart';

class LoginBlocCubit extends Cubit<LoginState> {
  final LoginService loginService = LoginService(navigatorKey);
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  LoginBlocCubit() : super(const LoginState.initial());

  Future<void> loginUser({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginState.failure("All fields are required"));
      return;
    }

    emit(const LoginState.loading());

    try {
      final token = await loginService.loginUser(email: email, password: password);

      final payload = JwtDecoder.decode(token);
      final userId = payload['id']?.toString();

      // Check if the user is new by comparing userId
      final previousUserId = await _storage.read(key: 'userId');
      final isNewUser = previousUserId == null || previousUserId != userId;

      if (isNewUser) {
        await RecentlyPlayedManager.clearRecentlyPlayed();
        await FavoriteSongService().clearFavoriteSongs();
      }

      await _storage.write(key: 'jwt_token', value: token);
      await _storage.write(key: 'authType', value: 'email');
      if (userId != null) {
        await _storage.write(key: 'userId', value: userId);
      }

      emit(LoginState.success(token, userId ?? ''));
    } catch (e) {
      emit(LoginState.failure(e.toString()));
    }
  }

  Future<void> logout() async {
    await loginService.logout();
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'authType');
    await RecentlyPlayedManager.clearRecentlyPlayed();
    await FavoriteSongService().clearFavoriteSongs();
    emit(const LoginState.initial());
  }
}
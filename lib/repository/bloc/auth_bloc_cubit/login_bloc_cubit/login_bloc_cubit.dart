import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service/auth_service/login_service.dart';

class LoginBlocCubit extends Cubit<LoginState> {
  final LoginService loginService = LoginService();

  LoginBlocCubit() : super(const LoginState.initial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginState.failure("All fields are required"));
      return;
    }

    emit(const LoginState.loading());

    try {
      final userId = await loginService.loginUser(email: email, password: password);
      final token = await loginService.loginUser(
        email: email,
        password: password,
      );
      emit(LoginState.success(token,userId));
    } catch (e) {
      emit(LoginState.failure(e.toString()));
    }
  }

  Future<void> logout() async {
    await loginService.logout();
    emit(const LoginState.initial());
  }
}

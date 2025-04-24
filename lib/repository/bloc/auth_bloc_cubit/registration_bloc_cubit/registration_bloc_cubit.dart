
import 'package:audionyx/repository/bloc/auth_bloc_cubit/registration_bloc_cubit/registration_state.dart';
import 'package:audionyx/repository/service/auth_service/google_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service/auth_service/registration_service.dart';

class RegistrationBlocCubit extends Cubit<RegistrationState> {
  final RegistrationService registrationService = RegistrationService();

  RegistrationBlocCubit() : super(const RegistrationState.initial());

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if ([name, email, password].any((e) => e.isEmpty)) {
      emit(const RegistrationState.failure('All fields are required'));
      return;
    }

    emit(const RegistrationState.loading());

    try {
      final message = await registrationService.registerUser(
        name: name,
        email: email,
        password: password,
      );
      emit(RegistrationState.success(message));
    } catch (e) {
      emit(RegistrationState.failure(e.toString()));
    }
  }

  Future<void> onRegisterGoogleUser() async {
    emit(RegistrationLoading());
    try {
      final result = await GoogleAuthService().signInWithGoogle();
      if (result != null) {
        emit(RegistrationSuccess(result['message']?? 'error'));
      } else {
        emit(RegistrationFailure('Google Sign-In failed'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_state.freezed.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const factory RegistrationState.initial() = RegistrationInitial;
  const factory RegistrationState.loading() = RegistrationLoading;
  const factory RegistrationState.google() = RegistrationGoogle;
  const factory RegistrationState.success(String message) = RegistrationSuccess;
  const factory RegistrationState.failure(String error) = RegistrationFailure;
}

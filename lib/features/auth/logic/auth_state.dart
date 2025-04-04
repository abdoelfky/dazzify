part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthVerifyOtpLoadingState extends AuthState {}

final class AuthVerifyNumberSuccessState extends AuthState {
  final bool isResend;

  const AuthVerifyNumberSuccessState({required this.isResend});

  @override
  List<Object> get props => [isResend];
}

final class AuthVerifyNumberFailureState extends AuthState {}

final class AuthValidateNewUserOtpSuccess extends AuthState {}

final class AuthValidateExistUserOtpSuccess extends AuthState {}

final class AuthValidateUserOtpFailure extends AuthState {
  final String error;

  const AuthValidateUserOtpFailure(this.error);
}

/// guest mode



final class AuthAddUserInfoSuccessState extends AuthState {}

final class AuthAddUserInfoFailureState extends AuthState {
  final String error;

  const AuthAddUserInfoFailureState(this.error);
}

final class GuestModeLoadingState extends AuthState {}

final class GuestModeSuccessState extends AuthState {}

final class GuestModeFailureState extends AuthState {
  final String error;

  const GuestModeFailureState(this.error);
}

final class AppTermsLoadingState extends AuthState {}

final class AppTermsSuccessState extends AuthState {
  final List<String> appTerms;

  const AppTermsSuccessState({required this.appTerms});
}

final class AppTermsFailureState extends AuthState {
  final String errorMessage;

  const AppTermsFailureState({required this.errorMessage});
}

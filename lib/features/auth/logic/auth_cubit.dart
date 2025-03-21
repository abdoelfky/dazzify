import 'package:dazzify/features/auth/data/models/auth_model.dart';
import 'package:dazzify/features/auth/data/repositories/auth_repository.dart';
import 'package:dazzify/features/auth/data/requests/add_user_info_request.dart';
import 'package:dazzify/features/auth/data/requests/send_otp_request.dart';
import 'package:dazzify/features/auth/data/requests/validate_otp_request.dart';
import 'package:dazzify/features/notifications/logic/app_notifications/app_notifications_cubit.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final AppNotificationsCubit _appNotificationsCubit;
  final SettingsCubit _settingsCubit;

  AuthCubit(
    this._authRepository,
    this._appNotificationsCubit,
    this._settingsCubit,
  ) : super(AuthInitialState());
  late String phoneNumber;
  late String registerToken;
  late AuthModel authModel;

  String _getCurrentLanguageCode() => _settingsCubit.currentLanguageCode;

  Future<void> sendOtp({
    String? phoneNumber,
  }) async {
    emit(AuthLoadingState());
    final request = SendOtpRequest(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
    final result = await _authRepository.sendOtp(request);
    result.fold(
      (failure) => emit(AuthVerifyNumberFailureState()),
      (success) {
        authModel = success;
        if (phoneNumber != null) {
          this.phoneNumber = phoneNumber;
        }
        emit(AuthVerifyNumberSuccessState(isResend: phoneNumber == null));
      },
    );
  }

  void validateOtp({
    required String otpCode,
  }) async {
    emit(AuthVerifyOtpLoadingState());
    final request = ValidateOtpRequest(
      phoneNumber: phoneNumber,
      otpCode: otpCode,
      lang: authModel.isNewUser ? null : _getCurrentLanguageCode(),
    );

    if (authModel.isNewUser) {
      final result = await _authRepository.validateNonExistUserOtpCode(
        request: request,
      );
      result.fold((failure) {
        emit(AuthValidateUserOtpFailure(failure.message));
      }, (success) {
        registerToken = success;
        emit(AuthValidateNewUserOtpSuccess());
      });
    } else {
      final result = await _authRepository.validateExistUserOtpCode(
        request: request,
      );
      result.fold(
        (failure) {
          emit(AuthValidateUserOtpFailure(failure.message));
        },
        (success) {
          emit(AuthValidateExistUserOtpSuccess());
          _appNotificationsCubit.subscribeToNotifications();
        },
      );
    }
  }

  void addUserInfo({
    required String fullName,
    required String gender,
    required String email,
    required String birthDay,
    // required int age,
  }) async {
    emit(AuthLoadingState());

    final request = AddUserInfoRequest(
      fullName: fullName,
      gender: gender,
      email: email,
      birthDay: birthDay,
      // age: age,
      lang: _getCurrentLanguageCode(),
    );

    final result = await _authRepository.addUserInformation(
      request: request,
      registerToken: registerToken,
    );
    result.fold(
      (failure) => emit(AuthAddUserInfoFailureState(failure.message)),
      (success) {
        emit(AuthAddUserInfoSuccessState());
        _appNotificationsCubit.subscribeToNotifications();
      },
    );
  }

  Future<void> getAppTerms() async {
    emit(AppTermsLoadingState());

    final result = await _authRepository.getAppTerms(
      lang: _getCurrentLanguageCode(),
    );
    result.fold(
        (failure) => emit(AppTermsFailureState(errorMessage: failure.message)),
        (appTerms) => emit(AppTermsSuccessState(appTerms: appTerms)));
  }
}

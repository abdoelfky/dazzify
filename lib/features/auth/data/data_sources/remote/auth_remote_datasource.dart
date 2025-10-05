import 'package:dazzify/features/auth/data/models/auth_model.dart';
import 'package:dazzify/features/auth/data/models/app_config_model.dart';
import 'package:dazzify/features/auth/data/models/tokens_model.dart';
import 'package:dazzify/features/auth/data/requests/add_user_info_request.dart';
import 'package:dazzify/features/auth/data/requests/send_otp_request.dart';
import 'package:dazzify/features/auth/data/requests/validate_otp_request.dart';

abstract class AuthRemoteDatasource {
  const AuthRemoteDatasource();

  Future<AuthModel> sendOtp({required SendOtpRequest request});

  Future<String> validateNonExistUserOtpCode({
    required ValidateOtpRequest request,
  });

  Future<TokensModel> validateExistUserOtpCode({
    required ValidateOtpRequest request,
  });

  Future<AppConfigModel> guestMode({String? languagePreference});

  Future<TokensModel> addUserInformation({
    required AddUserInfoRequest request,
    required String registerToken,
  });

  Future<TokensModel> refreshUserAccessToken(String refreshToken);

  Future<List<String>> getAppTerms({required String lang});
}

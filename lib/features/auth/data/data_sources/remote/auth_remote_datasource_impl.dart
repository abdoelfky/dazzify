import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/features/auth/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:dazzify/features/auth/data/models/auth_model.dart';
import 'package:dazzify/features/auth/data/models/tokens_model.dart';
import 'package:dazzify/features/auth/data/requests/add_user_info_request.dart';
import 'package:dazzify/features/auth/data/requests/send_otp_request.dart';
import 'package:dazzify/features/auth/data/requests/validate_otp_request.dart';

class AuthRemoteDatasourceImpl extends AuthRemoteDatasource {
  final ApiConsumer _apiConsumer;

  const AuthRemoteDatasourceImpl(this._apiConsumer);

  @override
  Future<AuthModel> sendOtp({required SendOtpRequest request}) async {
    return await _apiConsumer.post<AuthModel>(
      ApiConstants.sendOtpPath,
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: AuthModel.fromJson,
      body: request.toJson(),
    );
  }

  @override
  Future<String> validateNonExistUserOtpCode({
    required ValidateOtpRequest request,
  }) async {
    return await _apiConsumer.post<String>(
      ApiConstants.validateNonExistUserOtpPath,
      responseReturnType: ResponseReturnType.primitiveWithKey,
      primitiveKey: "registerToken",
      body: request.toJson(),
    );
  }

  @override
  Future<TokensModel> validateExistUserOtpCode({
    required ValidateOtpRequest request,
  }) async {
    return await _apiConsumer.post<TokensModel>(
      ApiConstants.validateExistUserOtpPath,
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: TokensModel.fromJson,
      body: request.toJson(),
    );
  }

  @override
  Future<TokensModel> addUserInformation({
    required AddUserInfoRequest request,
    required String registerToken,
  }) async {
    return await _apiConsumer.post<TokensModel>(
      ApiConstants.addInformationPath,
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: TokensModel.fromJson,
      body: request.toJson(),
      userAccessToken: registerToken,
    );
  }

  @override
  Future<TokensModel> refreshUserAccessToken(String refreshToken) async {
    return await _apiConsumer.get<TokensModel>(
      ApiConstants.refreshUserAccessTokenPath,
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: TokensModel.fromJson,
      headers: {"X-Refresh-Token": refreshToken},
    );
  }

  @override
  Future<List<String>> getAppTerms({required lang}) async {
    return await _apiConsumer.get<String>(
      ApiConstants.appTerms,
      responseReturnType: ResponseReturnType.primitiveList,
      queryParameters: {
        AppConstants.lang: lang,
      },
    );
  }
}

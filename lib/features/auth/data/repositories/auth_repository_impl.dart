import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/app_config_manager.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart';
import 'package:dazzify/features/auth/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:dazzify/features/auth/data/models/app_config_model.dart';
import 'package:dazzify/features/auth/data/models/auth_model.dart';
import 'package:dazzify/features/auth/data/models/tokens_model.dart';
import 'package:dazzify/features/auth/data/repositories/auth_repository.dart';
import 'package:dazzify/features/auth/data/requests/add_user_info_request.dart';
import 'package:dazzify/features/auth/data/requests/send_otp_request.dart';
import 'package:dazzify/features/auth/data/requests/validate_otp_request.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;

  const AuthRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
  );

  @override
  Future<Either<Failure, AuthModel>> sendOtp(SendOtpRequest request) async {
    try {
      AuthModel response = await _remoteDatasource.sendOtp(request: request);

      return Right(response);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, String>> validateNonExistUserOtpCode({
    required ValidateOtpRequest request,
  }) async {
    try {
      _localDatasource.storeGuestMode(false);

      String response = await _remoteDatasource.validateNonExistUserOtpCode(
        request: request,
      );

      return Right(response);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, TokensModel>> validateExistUserOtpCode({
    required ValidateOtpRequest request,
  }) async {
    try {
      _localDatasource.storeGuestMode(false);

      TokensModel response = await _remoteDatasource.validateExistUserOtpCode(
        request: request,
      );
      _localDatasource.storeUserTokens(response);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, AppConfigModel>> guestMode({bool isClicked = false}) async {
    try {
      AppConfigModel response = await _remoteDatasource.guestMode();
      AppConfigManager.config = response;
      ///from API
      _localDatasource.storeGuestModeSession(response.guestMode);

      if(isClicked) {
        _localDatasource.storeUserTokens(TokensModel(
          accessToken: response.guestToken!,
          accessTokenExpireTime: response.guestTokenExpireTime!,
          refreshTokenExpireTime: response.guestTokenExpireTime!));

        _localDatasource.storeGuestMode(true);

      }
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, TokensModel>> addUserInformation({
    required AddUserInfoRequest request,
    required String registerToken,
  }) async {
    try {
      final response = await _remoteDatasource.addUserInformation(
        request: request,
        registerToken: registerToken,
      );
      _localDatasource.storeUserTokens(response);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, String>> getUserAccessToken() async {
    try {
      final String accessToken = _localDatasource.getAccessToken();
      return Right(accessToken);
    } on AccessTokenException {
      try {
        final String refreshToken = await _getRefreshToken();
        try {
          final TokensModel updatedToken =
              await _refreshUserAccessToken(refreshToken);
          _localDatasource.updateAccessToken(updatedToken);
          return Right(updatedToken.accessToken);
        } on ServerException catch (exception) {
          return Left(ApiFailure(message: exception.message!));
        }
      } on RefreshTokenException catch (exception) {
        return Left(SessionFailure(message: exception.message!));
      }
    }
  }

  Future<String> _getRefreshToken() async {
    try {
      return await _localDatasource.getRefreshToken();
    } on RefreshTokenException {
      rethrow;
    }
  }

  Future<TokensModel> _refreshUserAccessToken(String refreshToken) async {
    return await _remoteDatasource.refreshUserAccessToken(refreshToken);
  }

  @override
  bool isUserAuthenticated() {
    return _localDatasource.checkIfTokensExist();
  }

  @override
  Future<void> deleteUserTokens() async {
    _localDatasource.checkGuestMode();
    await _localDatasource.deleteAuthTokens();
  }

  @override
  Future<Either<Failure, List<String>>> getAppTerms({
    required String lang,
  }) async {
    try {
      final response = await _remoteDatasource.getAppTerms(lang: lang);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }
}

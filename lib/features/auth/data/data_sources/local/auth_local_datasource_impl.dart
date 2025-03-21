import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart';
import 'package:dazzify/features/auth/data/models/tokens_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final Box<dynamic> settingsDatabase = Hive.box(
    AppConstants.appSettingsDatabase,
  );

  DateTime currentTime() => DateTime.now().toUtc();

  @override
  bool checkIfTokensExist() {
    if (settingsDatabase.containsKey(AppConstants.userTokensKey)) {
      final TokensModel tokens =
          settingsDatabase.get(AppConstants.userTokensKey)!;
      debugPrint("ACCESS TOKEN: ${tokens.accessToken}");
      return currentTime().isBefore(tokens.refreshTokenExpireTime!);
    } else {
      return false;
    }
  }

  @override
  Future<void> storeUserTokens(TokensModel tokens) async {
    await settingsDatabase.put(AppConstants.userTokensKey, tokens);
  }

  @override
  String getAccessToken() {
    if (checkIfTokensExist()) {
      final TokensModel tokens =
          settingsDatabase.get(AppConstants.userTokensKey)!;
      if (currentTime().isBefore(tokens.accessTokenExpireTime)) {
        return settingsDatabase.get(AppConstants.userTokensKey)!.accessToken;
      } else {
        throw const AccessTokenException('Access Token Expired');
      }
    } else {
      throw const AccessTokenException('Access Token Expired');
    }
  }

  @override
  Future<String> getRefreshToken() async {
    if (checkIfTokensExist()) {
      final TokensModel tokens =
          settingsDatabase.get(AppConstants.userTokensKey)!;
      if (currentTime().isBefore(tokens.refreshTokenExpireTime!)) {
        return settingsDatabase.get(AppConstants.userTokensKey)!.refreshToken;
      } else {
        await settingsDatabase.delete(AppConstants.userTokensKey);
        throw const RefreshTokenException('Your session expired.');
      }
    } else {
      throw const RefreshTokenException('Your session expired.');
    }
  }

  @override
  Future<void> deleteAuthTokens() async {
    if (settingsDatabase.containsKey(AppConstants.userTokensKey)) {
      await settingsDatabase.delete(AppConstants.userTokensKey);
    }
  }

  @override
  Future<void> updateAccessToken(TokensModel updatedToken) async {
    if (settingsDatabase.containsKey(AppConstants.userTokensKey)) {
      final TokensModel storedTokens = await settingsDatabase.get(
        AppConstants.userTokensKey,
      );
      final newTokens = updatedToken.copyWith(
        refreshToken: storedTokens.refreshToken,
        refreshTokenExpireTime: storedTokens.refreshTokenExpireTime,
      );
      settingsDatabase.put(AppConstants.userTokensKey, newTokens);
    } else {
      throw const RefreshTokenException('Your session expired.');
    }
  }
}

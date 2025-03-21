import 'package:dazzify/features/auth/data/models/tokens_model.dart';

abstract class AuthLocalDatasource {
  bool checkIfTokensExist();

  Future<void> storeUserTokens(TokensModel tokens);

  String getAccessToken();

  Future<String> getRefreshToken();

  Future<void> deleteAuthTokens();

  Future<void> updateAccessToken(TokensModel updatedToken);
}

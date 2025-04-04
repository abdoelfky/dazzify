import 'package:dazzify/features/auth/data/models/guest_model.dart';
import 'package:dazzify/features/auth/data/models/tokens_model.dart';

abstract class AuthLocalDatasource {
  bool checkIfTokensExist();

  bool checkGuestMode();

  Future<void> storeUserTokens(TokensModel tokens);

  Future<void> storeGuestMode(bool guestMode);


  ///if  guest mode is from API true
  bool checkGuestModeSession();

  Future<void> storeGuestModeSession(bool guestMode);

  String getAccessToken();

  Future<String> getRefreshToken();

  Future<void> deleteAuthTokens();

  Future<void> updateAccessToken(TokensModel updatedToken);
}

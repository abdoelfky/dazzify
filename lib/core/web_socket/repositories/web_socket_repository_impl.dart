import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/web_socket/data_sources/web_socket_service.dart';
import 'package:dazzify/core/web_socket/repositories/web_socket_repository.dart';
import 'package:dazzify/core/web_socket/requests/chat_opened_request.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart';
import 'package:dazzify/features/auth/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:dazzify/features/auth/data/models/tokens_model.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: WebSocketRepository)
class WebSocketRepositoryImpl extends WebSocketRepository {
  final WebSocketService webSocketService;
  final AuthLocalDatasource authLocalDatasource;
  final AuthRemoteDatasource authRemoteDatasource;

  WebSocketRepositoryImpl({
    required this.authLocalDatasource,
    required this.authRemoteDatasource,
    required this.webSocketService,
  });

  @override
  Future<void> connectToWebSocket() async {
    try {
      final String userAccessToken = authLocalDatasource.getAccessToken();
      webSocketService.connectToSocket(userAccessToken: userAccessToken);
    } on AccessTokenException {
      try {
        final String refreshToken = await authLocalDatasource.getRefreshToken();
        final TokensModel updatedTokens =
            await authRemoteDatasource.refreshUserAccessToken(refreshToken);
        authLocalDatasource.updateAccessToken(updatedTokens);
        webSocketService.connectToSocket(
          userAccessToken: updatedTokens.accessToken,
        );
      } on Exception {
        getIt<TokensCubit>().emitSessionExpired();
      }
    }
  }

  @override
  Stream<WebSocketResponse> socketEventPass() =>
      webSocketService.socketEventStream();

  @override
  void sendChatOpenCloseEvent(ChatOpenedRequest request) {
    webSocketService.sendChatOpenCloseEvent(request);
  }

  @override
  Future<void> disconnectWebSocket() => webSocketService.disconnectWebSocket();
}

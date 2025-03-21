import 'package:dazzify/core/web_socket/requests/chat_opened_request.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';

abstract class WebSocketService {
  Future<void> connectToSocket({required String userAccessToken});

  Stream<WebSocketResponse> socketEventStream();

  Future<void> disconnectWebSocket();

  void sendChatOpenCloseEvent(ChatOpenedRequest request);
}

import 'package:dazzify/core/web_socket/requests/chat_opened_request.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';

abstract class WebSocketRepository {
  Future<void> connectToWebSocket();

  Stream<WebSocketResponse> socketEventPass();

  Future<void> disconnectWebSocket();

  void sendChatOpenCloseEvent(ChatOpenedRequest request);
}

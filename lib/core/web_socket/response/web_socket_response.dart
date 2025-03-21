enum WebSocketDataType { message, booking, ban, review }

class WebSocketResponse {
  final dynamic data;
  final WebSocketDataType type;

  const WebSocketResponse({
    this.data,
    required this.type,
  });
}

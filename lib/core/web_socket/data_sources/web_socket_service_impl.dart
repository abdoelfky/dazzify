import 'dart:async';

import 'package:dazzify/core/config/build_config.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/functions.dart';
import 'package:dazzify/core/web_socket/data_sources/web_socket_service.dart';
import 'package:dazzify/core/web_socket/requests/chat_opened_request.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';
import 'package:dazzify/features/booking/data/models/booking_review_request_model.dart';
import 'package:dazzify/features/booking/data/models/last_active_booking_model.dart';
import 'package:dazzify/features/chat/data/models/branch_message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as SOCKET;

@LazySingleton(as: WebSocketService)
class WebSocketServiceImpl extends WebSocketService {
  SOCKET.Socket? socketConsumer;
  StreamController<WebSocketResponse> socketEventPassStream =
      StreamController<WebSocketResponse>.broadcast();

  @override
  Future<void> connectToSocket({
    required String userAccessToken,
  }) async {
    socketConsumer = SOCKET.io(getIt<BuildConfig>().baseUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'auth': {'token': userAccessToken},
    });
    socketConsumer!.connect();
    socketConsumer!.on('new_message', (data) {
      debugPrint("SOCKET NEW MESSAGE : $data");

      final WebSocketResponse newMessage = WebSocketResponse(
        data: BranchMessageModel.fromJson(data),
        type: WebSocketDataType.message,
      );

      socketEventPassStream.sink.add(newMessage);
    });

    socketConsumer!.on('ban', (data) {
      debugPrint("This User Is Banned");
      final WebSocketResponse ban = WebSocketResponse(
        type: WebSocketDataType.ban,
      );
      socketEventPassStream.sink.add(ban);
    });

    socketConsumer!.on('booking', (data) {
      debugPrint("New Last Active Booking List Received : $data");

      final WebSocketResponse newBookingList = WebSocketResponse(
        data: toModelList<LastActiveBookingModel>(
          data,
          LastActiveBookingModel.fromJson,
        ),
        type: WebSocketDataType.booking,
      );

      socketEventPassStream.sink.add(newBookingList);
    });
    socketConsumer!.on('review', (data) {
      if (kDebugMode) {
        print("Booking Review Request Received : $data");
      }
      final WebSocketResponse bookReviewRequest = WebSocketResponse(
        data: BookingReviewRequestModel.fromJson(data),
        type: WebSocketDataType.review,
      );

      socketEventPassStream.sink.add(bookReviewRequest);
    });
    socketConsumer!.onError((data) => throw const DataException());
  }

  @override
  Stream<WebSocketResponse> socketEventStream() => socketEventPassStream.stream;

  @override
  void sendChatOpenCloseEvent(ChatOpenedRequest request) {
    socketConsumer?.emit(request.event, request.toJson());
  }

  @override
  Future<void> disconnectWebSocket() async {
    if (socketConsumer != null) {
      socketConsumer!.clearListeners();
      socketConsumer!.disconnect();
      socketConsumer = null;
    }
    if (!socketEventPassStream.isClosed) {
      await socketEventPassStream.close();
    }
  }
}

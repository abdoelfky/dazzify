import 'package:bloc/bloc.dart';
import 'package:dazzify/core/web_socket/repositories/web_socket_repository.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'socket_state.dart';

@LazySingleton()
class SocketCubit extends Cubit<SocketState> {
  final WebSocketRepository socketRepository;
  final TokensCubit tokensCubit;

  SocketCubit(this.socketRepository, this.tokensCubit) : super(SocketInitial());

  void connectToWebSocket() async {
    await socketRepository.connectToWebSocket().then((value) {
      startWebsocketConnection();
    });
  }

  void disconnectWebSocket() => socketRepository.disconnectWebSocket();

  void startWebsocketConnection() {
    socketRepository.socketEventPass().listen(
      (WebSocketResponse response) {
        if (response.type == WebSocketDataType.ban) {
          tokensCubit.emitSessionExpired();
        }
      },
    );
  }
}

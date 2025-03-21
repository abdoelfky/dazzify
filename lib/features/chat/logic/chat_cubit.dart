import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/services/image_picking_service.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/web_socket/repositories/web_socket_repository.dart';
import 'package:dazzify/core/web_socket/requests/chat_opened_request.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';
import 'package:dazzify/features/chat/data/models/branch_message_model.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/chat/data/repositories/chat_repository.dart';
import 'package:dazzify/features/chat/data/requests/send_message_request.dart';
import 'package:dazzify/features/chat/logic/conversations_cubit.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'chat_state.dart';

@Injectable()
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final WebSocketRepository _webSocketRepository;
  final ImagePickingService _imagePickingService;
  late final ConversationsCubit conversationsCubit;
  late final String branchId;
  late final String branchName;
  late final BrandModel brand;

  ChatCubit(
    this._chatRepository,
    this._imagePickingService,
    this._webSocketRepository,
  ) : super(const ChatState()) {
    _webSocketRepository.sendChatOpenCloseEvent(
      ChatOpenedRequest(branchId: branchId),
    );
  }

  void setUp({
    required String branchId,
    required String branchName,
    required BrandModel brand,
  }) {
    this.branchId = branchId;
    this.branchName = branchName;
    this.brand = brand;
  }

  Future<void> getAllMessages() async {
    emit(state.copyWith(fetchingMessagesState: UiState.loading));
    Either<Failure, List<MessageModel>> result =
        await _chatRepository.getChatMessages(
      branchId: branchId,
    );
    if (!isClosed) {
      result.fold(
        (failure) => emit(
          state.copyWith(
            errorMessage: failure.message,
            fetchingMessagesState: UiState.failure,
          ),
        ),
        (messages) async {
          emit(
            state.copyWith(
              messages: messages.reversed.toList(),
              fetchingMessagesState: UiState.success,
            ),
          );
          await _startWebsocketConnection();
        },
      );
    }
  }

  Future<void> sendMessage(
      {required String messageType,
      String? text,
      String? serviceId,
      Function(MessageModel message)? onMessageSent}) async {
    File? image;
    emit(state.copyWith(sendingMessageState: UiState.loading));
    if (messageType == MessageType.photo.name) {
      image = await _imagePickingService.pickImage(
        imageSource: ImageSource.gallery,
      );
    }

    Either<Failure, MessageModel> result = await _chatRepository.sendMessage(
      request: SendMessageRequest(
        branchId: branchId,
        messageType: messageType,
        content: text,
        image: image,
        serviceId: serviceId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          sendingMessageState: UiState.failure,
        ),
      ),
      (lastMessage) {
        List<MessageModel> newMessages = [lastMessage, ...state.messages];
        if (onMessageSent != null) onMessageSent(lastMessage);
        conversationsCubit.updateLastMessage(
          branchMessage: BranchMessageModel(
            branchId: branchId,
            message: lastMessage,
          ),
        );

        emit(
          state.copyWith(
            messages: newMessages,
            sendingMessageState: UiState.success,
          ),
        );
      },
    );
  }

  Future<void> _startWebsocketConnection() async {
    _webSocketRepository.socketEventPass().listen(
      (WebSocketResponse response) {
        if (response.type == WebSocketDataType.message) {
          final BranchMessageModel branchMessage = response.data;
          if (branchMessage.branchId == branchId) {
            emit(
              state.copyWith(
                messages: [branchMessage.message, ...state.messages],
              ),
            );
            conversationsCubit.updateLastMessage(
              branchMessage: branchMessage,
            );
          }
        }
      },
    );
  }

  @override
  Future<void> close() {
    _webSocketRepository.sendChatOpenCloseEvent(
      ChatOpenedRequest(branchId: branchId),
    );
    return super.close();
  }
}

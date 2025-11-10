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
  ) : super(const ChatState());

  void setUp({
    required String branchId,
    required String branchName,
    required BrandModel brand,
  }) {
    this.branchId = branchId;
    this.branchName = branchName;
    this.brand = brand;
    _webSocketRepository.sendChatOpenCloseEvent(
      ChatOpenedRequest(
        branchId: branchId,
        type: "chat",
        event: "off_notifications",
      ),
    );  }

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
    
    // Pick image if message type is photo
    if (messageType == MessageType.photo.name) {
      image = await _imagePickingService.pickImage(
        imageSource: ImageSource.gallery,
      );
      
      // If user cancelled image selection, return early
      if (image == null) {
        emit(state.copyWith(sendingMessageState: UiState.initial));
        return;
      }
    }

    // Create a temporary pending message to show in UI immediately
    final pendingMessage = MessageModel(
      sender: 'user',
      messageType: messageType,
      content: MessageContentModel(
        message: text ?? '',
        image: image?.path ?? '', // Use local path temporarily
      ),
      createdAt: DateTime.now().toIso8601String(),
      sendStatus: messageType == MessageType.photo.name ? 'uploading' : 'pending',
      uploadProgress: messageType == MessageType.photo.name ? 0.0 : null,
      localFilePath: image?.path,
    );

    // Add pending message to UI immediately
    List<MessageModel> messagesWithPending = [pendingMessage, ...state.messages];
    emit(state.copyWith(
      messages: messagesWithPending,
      sendingMessageState: UiState.loading,
    ));

    // Send the message
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
      (failure) {
        // Update pending message to failed status
        final updatedMessages = state.messages.map((msg) {
          if (msg == pendingMessage) {
            return msg.copyWith(sendStatus: 'failed');
          }
          return msg;
        }).toList();
        
        emit(
          state.copyWith(
            errorMessage: failure.message,
            sendingMessageState: UiState.failure,
            messages: updatedMessages,
          ),
        );
      },
      (sentMessage) {
        // Replace pending message with the actual sent message
        final updatedMessages = state.messages.map((msg) {
          if (msg == pendingMessage) {
            return sentMessage.copyWith(sendStatus: 'sent');
          }
          return msg;
        }).toList();
        
        if (onMessageSent != null) onMessageSent(sentMessage);
        conversationsCubit.updateLastMessage(
          branchMessage: BranchMessageModel(
            branchId: branchId,
            message: sentMessage,
          ),
        );

        emit(
          state.copyWith(
            messages: updatedMessages,
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
      ChatOpenedRequest(branchId: branchId,event: 'on_notifications'),
    );
    return super.close();
  }
}

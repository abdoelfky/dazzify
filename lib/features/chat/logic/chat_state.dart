part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final UiState fetchingMessagesState;
  final UiState sendingMessageState;
  final String errorMessage;
  final List<MessageModel> messages;
  final UiState socketState;
  final String? sendingMessageType;

  const ChatState({
    this.fetchingMessagesState = UiState.initial,
    this.sendingMessageState = UiState.initial,
    this.socketState = UiState.initial,
    this.errorMessage = '',
    this.messages = const [],
    this.sendingMessageType,
  });

  @override
  List<Object?> get props => [
        fetchingMessagesState,
        sendingMessageState,
        socketState,
        errorMessage,
        messages,
        sendingMessageType,
      ];

  ChatState copyWith({
    UiState? fetchingMessagesState,
    UiState? sendingMessageState,
    String? errorMessage,
    List<MessageModel>? messages,
    UiState? socketState,
    String? sendingMessageType,
  }) {
    return ChatState(
      fetchingMessagesState:
          fetchingMessagesState ?? this.fetchingMessagesState,
      sendingMessageState: sendingMessageState ?? this.sendingMessageState,
      errorMessage: errorMessage ?? this.errorMessage,
      messages: messages ?? this.messages,
      socketState: socketState ?? this.socketState,
      sendingMessageType: sendingMessageType ?? this.sendingMessageType,
    );
  }
}

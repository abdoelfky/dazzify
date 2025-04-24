part of 'conversations_cubit.dart';

class ConversationsState extends Equatable {
  final UiState blocState;
  final String errorMessage;
  final List<ConversationModel> conversations;

  const ConversationsState({
    this.blocState = UiState.initial,
    this.errorMessage = '',
    this.conversations = const [],
  });

  ConversationsState copyWith({
    UiState? blocState,
    String? errorMessage,
    List<ConversationModel>? conversations,
  }) {
    return ConversationsState(
      blocState: blocState ?? this.blocState,
      errorMessage: errorMessage ?? this.errorMessage,
      conversations: conversations ?? this.conversations,
    );
  }

  @override
  List<Object> get props => [
        blocState,
        errorMessage,
        conversations,
      ];
}

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/web_socket/repositories/web_socket_repository.dart';
import 'package:dazzify/core/web_socket/response/web_socket_response.dart';
import 'package:dazzify/features/chat/data/models/branch_message_model.dart';
import 'package:dazzify/features/chat/data/models/chat_branch_model.dart';
import 'package:dazzify/features/chat/data/models/conversation_model.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/chat/data/repositories/chat_repository.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'conversations_state.dart';

@Injectable()
class ConversationsCubit extends Cubit<ConversationsState> {
  final ChatRepository _chatRepository;
  final WebSocketRepository _webSocketRepository;

  ConversationsCubit(
    this._chatRepository,
    this._webSocketRepository,
  ) : super(const ConversationsState());

  Future<void> getConversations() async {
    emit(state.copyWith(blocState: UiState.loading));

    Either<Failure, List<ConversationModel>> result =
        await _chatRepository.getConversations();

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          blocState: UiState.failure,
        ),
      ),
      (conversations) async {
        emit(
          state.copyWith(
            conversations: conversations,
            blocState: UiState.success,
          ),
        );
        await _startWebsocketConnection();
      },
    );
  }

  void updateLastMessage({
    required BranchMessageModel branchMessage,
  }) {
    emit(state.copyWith(
      blocState: UiState.loading,
    ));

    List<ConversationModel> conversations = List.from(state.conversations);

    for (var index = 0; index < conversations.length; index++) {
      if (conversations[index].branch.branchId == branchMessage.branchId) {
        ConversationModel newConversation = conversations[index].copyWith(
          lastMessage: branchMessage.message,
        );

        conversations.removeAt(index);
        conversations.insert(0, newConversation);

        break;
      }
    }
    emit(state.copyWith(
      conversations: conversations,
      blocState: UiState.success,
    ));
  }

  Future<void> _startWebsocketConnection() async {
    _webSocketRepository.socketEventPass().listen(
      (WebSocketResponse response) {
        if (response.type == WebSocketDataType.message) {
          final BranchMessageModel branchMessage = response.data;
          updateLastMessage(branchMessage: branchMessage);
        }
      },
    );
  }

  void addConversationIfNotExist({
    required BrandModel brand,
    required String branchId,
    required String branchName,
    required MessageModel lastMessage,
  }) {
    int index = state.conversations.indexWhere(
      (e) => e.branch.branchId == branchId,
    );
    if (index == -1) {
      final conversationsList = state.conversations;
      conversationsList.add(ConversationModel(
        brand: brand,
        branch: ChatBranchModel(branchName: branchName, branchId: branchId),
        lastMessage: lastMessage,
      ));
      emit(state.copyWith(
        conversations: conversationsList,
        blocState: UiState.success,
      ));
    }
  }
}

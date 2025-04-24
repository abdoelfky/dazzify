import 'package:dazzify/features/chat/data/models/conversation_model.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/chat/data/requests/send_message_request.dart';

abstract class ChatRemoteDatasource {
  const ChatRemoteDatasource();

  Future<List<ConversationModel>> getConversations();

  Future<List<MessageModel>> getChatMessages({
    required String branchId,
  });

  Future<MessageModel> sendMessage({
    required SendMessageRequest request,
  });
}

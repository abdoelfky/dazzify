import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/chat/data/models/conversation_model.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/chat/data/requests/send_message_request.dart';

abstract class ChatRepository {
  const ChatRepository();

  Future<Either<Failure, List<ConversationModel>>> getConversations();

  Future<Either<Failure, List<MessageModel>>> getChatMessages({
    required String branchId,
  });

  Future<Either<Failure, MessageModel>> sendMessage({
    required SendMessageRequest request,
  });
}

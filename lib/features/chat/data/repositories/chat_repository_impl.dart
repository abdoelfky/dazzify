import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/chat/data/data_sources/remote/chat_remote_datasource.dart';
import 'package:dazzify/features/chat/data/models/conversation_model.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/chat/data/repositories/chat_repository.dart';
import 'package:dazzify/features/chat/data/requests/send_message_request.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDatasource _remoteDatasource;

  const ChatRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<ConversationModel>>> getConversations() async {
    try {
      final conversations = await _remoteDatasource.getConversations();
      return Right(conversations);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getChatMessages({
    required String branchId,
  }) async {
    try {
      final messages = await _remoteDatasource.getChatMessages(
        branchId: branchId,
      );
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage({
    required SendMessageRequest request,
  }) async {
    try {
      final message = await _remoteDatasource.sendMessage(request: request);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }
}

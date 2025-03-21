import 'dart:async';

import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/chat/data/data_sources/remote/chat_remote_datasource.dart';
import 'package:dazzify/features/chat/data/models/conversation_model.dart';
import 'package:dazzify/features/chat/data/models/message_model.dart';
import 'package:dazzify/features/chat/data/requests/send_message_request.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' as http;
import 'package:injectable/injectable.dart';

@LazySingleton(as: ChatRemoteDatasource)
class ChatRemoteDatasourceImpl extends ChatRemoteDatasource {
  final ApiConsumer _apiConsumer;

  ChatRemoteDatasourceImpl(this._apiConsumer);

  @override
  Future<List<MessageModel>> getChatMessages({
    required String branchId,
  }) async {
    return await _apiConsumer.get<MessageModel>(
      ApiConstants.getChatMessages(branchId: branchId),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: MessageModel.fromJson,
    );
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    return await _apiConsumer.get<ConversationModel>(
      ApiConstants.getConversations,
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: ConversationModel.fromJson,
    );
  }

  @override
  Future<MessageModel> sendMessage({
    required SendMessageRequest request,
  }) async {
    late MultipartFile multipartFile;
    FormData formData = FormData();

    if (request.messageType == MessageType.photo.name) {
      String imageName = request.image!.path.split('/').last;
      String imageExtension = imageName.split('.').last;

      multipartFile = await MultipartFile.fromFile(
        request.image!.path,
        filename: imageName,
        contentType: http.MediaType(
          AppConstants.image,
          imageExtension,
        ),
      );

      formData.files.add(MapEntry(
        AppConstants.content,
        multipartFile,
      ));
    } else if (request.messageType == MessageType.txt.name) {
      formData.fields.add(MapEntry(
        AppConstants.content,
        request.content!,
      ));
    } else if (request.messageType == MessageType.service.name) {
      formData.fields.add(MapEntry(
        AppConstants.content,
        request.serviceId!,
      ));
    }

    formData.fields.add(MapEntry(
      AppConstants.messageType,
      request.messageType,
    ));

    return await _apiConsumer.post<MessageModel>(
      ApiConstants.sendMessage(branchId: request.branchId),
      body: formData,
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: MessageModel.fromJson,
    );
  }
}

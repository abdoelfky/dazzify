import 'package:dartz/dartz.dart';
import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/features/shared/data/models/comments/comment_model.dart';
import 'package:dazzify/features/shared/data/models/favorite_model.dart';
import 'package:dazzify/features/shared/data/requests/report_request.dart';
import 'package:dazzify/features/user/data/data_sources/user_remote_datasource.dart';
import 'package:dazzify/features/user/data/models/issue/issue_model.dart';
import 'package:dazzify/features/user/data/models/user/user_model.dart';
import 'package:dazzify/features/user/data/requests/add_comment_request.dart';
import 'package:dazzify/features/user/data/requests/add_reply_request.dart';
import 'package:dazzify/features/user/data/requests/create_issue_request.dart';
import 'package:dazzify/features/user/data/requests/get_comments_request.dart';
import 'package:dazzify/features/user/data/requests/get_issues_request.dart';
import 'package:dazzify/features/user/data/requests/update_comment_request.dart';
import 'package:dazzify/features/user/data/requests/update_profile_info_request.dart';
import 'package:dazzify/features/user/data/requests/update_profile_location_request.dart';
import 'package:dazzify/features/user/data/requests/verify_update_phone_number_request.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart' as parser;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final ApiConsumer _apiConsumer;

  UserRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<UserModel> getUser() async {
    return await _apiConsumer.get<UserModel>(
      ApiConstants.getUserData,
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: UserModel.fromJson,
    );
  }

  @override
  Future<Unit> deleteUser() async {
    return await _apiConsumer.delete(
      ApiConstants.getUserData,
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<Unit> updateProfileLang({required String lang}) async {
    return await _apiConsumer.put(
      ApiConstants.getUserData,
      body: {"languagePreference": lang},
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<Unit> updateProfileInfo({
    required UpdateProfileInfoRequest request,
  }) async {
    return await _apiConsumer.put(
      ApiConstants.updateUserInfo,
      body: request.toJson(),
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<UserModel> updateProfileImage({required XFile image}) async {
    return await _apiConsumer.put<UserModel>(
      ApiConstants.getUserData,
      headers: {
        'Content-Type': 'multipart/form-data',
      },
      body: FormData.fromMap({
        "picture": await MultipartFile.fromFile(
          image.path,
          filename: image.name,
          contentType: parser.MediaType("image", "png"),
        ),
      }),
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: UserModel.fromJson,
    );
  }

  @override
  Future<UserModel> updateProfileName({required String fullName}) async {
    return await _apiConsumer.put<UserModel>(
      ApiConstants.getUserData,
      body: {"fullName": fullName},
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: UserModel.fromJson,
    );
  }

  @override
  Future<UserModel> updateProfileLocation({
    required UpdateProfileLocationRequest request,
  }) async {
    return await _apiConsumer.put<UserModel>(
      ApiConstants.updateUserInfo,
      body: {AppConstants.location: request.toJson()},
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: UserModel.fromJson,
    );
  }

  @override
  Future<Unit> updatePhoneNumber({required String newPhoneNumber}) async {
    return await _apiConsumer.post<String>(
      ApiConstants.updatePhoneNumber,
      body: {"newPhoneNumber": newPhoneNumber},
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<Unit> verifyUpdatePhoneNumber({
    required VerifyUpdatePhoneNumberRequest request,
  }) async {
    return await _apiConsumer.post<Unit>(
      ApiConstants.verifyUpdatePhoneNumberOtp,
      body: request.toJson(),
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<void> addFavorite({required String serviceId}) async {
    await _apiConsumer.post(
      ApiConstants.getUserFavorites,
      body: {AppConstants.serviceId: serviceId},
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<List<FavoriteModel>> getFavoriteModels() async {
    return await _apiConsumer.get<FavoriteModel>(
      ApiConstants.getUserFavorites,
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: FavoriteModel.fromJson,
    );
  }

  @override
  Future<List<String>> getFavoriteIds() async {
    return await _apiConsumer.get<String>(
      ApiConstants.getUserFavorites,
      queryParameters: {
        AppConstants.data: AppConstants.returnDataById,
      },
      responseReturnType: ResponseReturnType.primitiveList,
    );
  }

  @override
  Future<void> removeFavorite({required String serviceId}) async {
    await _apiConsumer.delete(
      ApiConstants.getUserFavorites,
      body: {AppConstants.serviceId: serviceId},
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<bool> addLike({required String mediaId}) async {
    await _apiConsumer.post(
      ApiConstants.addLike(mediaId),
      responseReturnType: ResponseReturnType.unit,
    );
    return true;
  }

  @override
  Future<bool> removeLike({required String mediaId}) async {
    await _apiConsumer.delete(
      ApiConstants.removeLike(mediaId),
      responseReturnType: ResponseReturnType.unit,
    );
    return false;
  }

  @override
  Future<List<String>> getLikesIds() async {
    return await _apiConsumer.get<String>(
      ApiConstants.getUserLikes,
      responseReturnType: ResponseReturnType.primitiveList,
    );
  }

  @override
  Future<List<CommentModel>> getComments({
    required GetCommentsRequest request,
  }) async {
    return await _apiConsumer.get<CommentModel>(
      ApiConstants.getComments(mediaId: request.mediaId),
      queryParameters: {"page": request.page, "limit": request.limit},
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: CommentModel.fromJson,
    );
  }

  @override
  Future<CommentModel> addComment({
    required AddCommentRequest request,
  }) async {
    return await _apiConsumer.post<CommentModel>(
      ApiConstants.addComment(mediaId: request.mediaId),
      body: {"content": request.commentMessage},
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: CommentModel.fromJson,
    );
  }

  @override
  Future<Unit> deleteComment({required String commentId}) async {
    return await _apiConsumer.delete<Unit>(
      ApiConstants.deleteComment(commentId: commentId),
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<CommentModel> addReply({
    required AddReplyRequest request,
  }) async {
    return await _apiConsumer.post<CommentModel>(
      ApiConstants.addReply(commentId: request.commentId),
      body: {
        "content": request.replyContent,
      },
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: CommentModel.fromJson,
    );
  }

  @override
  Future<List<String>> getCommentLikesIds() async {
    return await _apiConsumer.get<String>(
      ApiConstants.getCommentLikes,
      responseReturnType: ResponseReturnType.primitiveList,
    );
  }

  @override
  Future<bool> addCommentLike({required String commentId}) async {
    await _apiConsumer.post(
      ApiConstants.addCommentLike(commentId: commentId),
      responseReturnType: ResponseReturnType.unit,
    );
    return true;
  }

  @override
  Future<bool> removeCommentLike({required String commentId}) async {
    await _apiConsumer.delete(
      ApiConstants.removeCommentLike(commentId: commentId),
      responseReturnType: ResponseReturnType.unit,
    );
    return false;
  }

  @override
  Future<List<IssueModel>> getIssues({
    required GetIssuesRequest request,
  }) async {
    return await _apiConsumer.get<IssueModel>(
      ApiConstants.issue,
      queryParameters: {
        AppConstants.page: request.page,
        AppConstants.limit: request.limit,
      },
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: IssueModel.fromJson,
    );
  }

  @override
  Future<Unit> createIssues({
    required CreateIssueRequest request,
  }) async {
    return await _apiConsumer.post<Unit>(
      ApiConstants.issue,
      body: request.toJson(),
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<CommentModel> updateComment({
    required UpdateCommentRequest request,
  }) async {
    return await _apiConsumer.put<CommentModel>(
      ApiConstants.updateComment(commentId: request.commentId),
      body: {"content": request.content},
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: CommentModel.fromJson,
    );
  }

  @override
  Future<Unit> report({required ReportRequest request}) async {
    return await _apiConsumer.post<Unit>(
      ApiConstants.report,
      body: request.toJson(),
      responseReturnType: ResponseReturnType.unit,
    );
  }
}

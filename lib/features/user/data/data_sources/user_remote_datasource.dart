import 'package:dartz/dartz.dart';
import 'package:dazzify/features/shared/data/models/comments/comment_model.dart';
import 'package:dazzify/features/shared/data/models/favorite_model.dart';
import 'package:dazzify/features/shared/data/requests/report_request.dart';
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
import 'package:image_picker/image_picker.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser();

  Future<Unit> deleteUser();

  Future<Unit> updateProfileLang({
    required String lang,
  });

  Future<Unit> updateProfileInfo({
    required UpdateProfileInfoRequest request,
  });

  Future<UserModel> updateProfileImage({
    required XFile image,
  });

  Future<UserModel> updateProfileName({
    required String fullName,
  });

  Future<UserModel> updateProfileLocation({
    required UpdateProfileLocationRequest request,
  });

  Future<Unit> updatePhoneNumber({
    required String newPhoneNumber,
  });

  Future<Unit> verifyUpdatePhoneNumber({
    required VerifyUpdatePhoneNumberRequest request,
  });

  Future<List<FavoriteModel>> getFavoriteModels();

  Future<List<String>> getFavoriteIds();

  Future<void> addFavorite({
    required String serviceId,
  });

  Future<void> removeFavorite({
    required String serviceId,
  });

  Future<bool> addLike({
    required String mediaId,
  });

  Future<bool> removeLike({
    required String mediaId,
  });

  Future<List<String>> getLikesIds();

  Future<List<CommentModel>> getComments({
    required GetCommentsRequest request,
  });

  Future<CommentModel> addComment({
    required AddCommentRequest request,
  });

  Future<Unit> deleteComment({
    required String commentId,
  });

  Future<CommentModel> addReply({
    required AddReplyRequest request,
  });

  Future<List<IssueModel>> getIssues({
    required GetIssuesRequest request,
  });

  Future<Unit> createIssues({
    required CreateIssueRequest request,
  });

  Future<List<String>> getCommentLikesIds();

  Future<bool> addCommentLike({
    required String commentId,
  });

  Future<bool> removeCommentLike({
    required String commentId,
  });

  Future<CommentModel> updateComment({
    required UpdateCommentRequest request,
  });

  Future<Unit> report({
    required ReportRequest request,
  });
}

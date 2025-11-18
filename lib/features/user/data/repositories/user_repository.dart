import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/shared/data/models/comments/comment_model.dart';
import 'package:dazzify/features/shared/data/models/favorite_model.dart';
import 'package:dazzify/features/shared/data/requests/report_request.dart';
import 'package:dazzify/features/user/data/models/issue/issue_model.dart';
import 'package:dazzify/features/user/data/models/tiered_coupon/tiered_coupon_model.dart';
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

abstract class UserRepository {
  Future<Either<Failure, UserModel>> getUser();

  Future<Either<Failure, Unit>> deleteUser();

  Future<Either<Failure, Unit>> updateProfileLang({
    required String lang,
  });

  Future<Either<Failure, Unit>> updateProfileInfo({
    required UpdateProfileInfoRequest request,
  });

  Future<Either<Failure, UserModel>> updateProfileImage({
    required XFile image,
  });

  Future<Either<Failure, UserModel>> updateProfileName({
    required String fullName,
  });

  Future<Either<Failure, UserModel>> updateProfileLocation({
    required UpdateProfileLocationRequest request,
  });

  Future<Either<Failure, Unit>> updatePhoneNumber({
    required String newPhoneNumber,
  });

  Future<Either<Failure, Unit>> verifyUpdatePhoneNumber({
    required VerifyUpdatePhoneNumberRequest request,
  });

  Future<Either<Failure, List<FavoriteModel>>> getFavoriteModels();

  Future<Either<Failure, List<String>>> getFavoriteIds();

  Future<Either<Failure, Unit>> addFavorite({
    required String serviceId,
  });

  Future<Either<Failure, Unit>> removeFavorite({
    required String serviceId,
  });

  Future<Either<Failure, bool>> addLike({
    required String mediaId,
  });

  Future<Either<Failure, bool>> removeLike({
    required String mediaId,
  });

  Future<Either<Failure, List<String>>> getLikesIds();

  Future<Either<Failure, List<CommentModel>>> getComments({
    required GetCommentsRequest request,
  });

  Future<Either<Failure, CommentModel>> addComment({
    required AddCommentRequest request,
  });

  Future<Either<Failure, Unit>> deleteComment({
    required String commentId,
  });

  Future<Either<Failure, CommentModel>> addReply({
    required AddReplyRequest request,
  });

  Future<Either<Failure, List<IssueModel>>> getIssues({
    required GetIssuesRequest request,
  });

  Future<Either<Failure, Unit>> createIssues({
    required CreateIssueRequest request,
  });

  Future<Either<Failure, List<String>>> getCommentLikesIds();

  Future<Either<Failure, bool>> addCommentLike({
    required String commentId,
  });

  Future<Either<Failure, bool>> removeCommentLike({
    required String commentId,
  });

  Future<Either<Failure, CommentModel>> updateComment({
    required UpdateCommentRequest request,
  });

  Future<Either<Failure, Unit>> report({
    required ReportRequest request,
  });

  Future<Either<Failure, List<TieredCouponModel>>> getTieredCouponRewards();

  Future<Either<Failure, String>> openNewRewardLevel();
}

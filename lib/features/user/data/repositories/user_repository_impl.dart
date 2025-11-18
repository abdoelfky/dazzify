import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/shared/data/models/comments/comment_model.dart';
import 'package:dazzify/features/shared/data/models/favorite_model.dart';
import 'package:dazzify/features/shared/data/requests/report_request.dart';
import 'package:dazzify/features/user/data/data_sources/user_remote_datasource.dart';
import 'package:dazzify/features/user/data/models/issue/issue_model.dart';
import 'package:dazzify/features/user/data/models/tiered_coupon/tiered_coupon_model.dart';
import 'package:dazzify/features/user/data/models/user/user_model.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
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
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  const UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final user = await _remoteDataSource.getUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser() async {
    try {
      await _remoteDataSource.deleteUser();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfileLang({
    required String lang,
  }) async {
    try {

      await _remoteDataSource.updateProfileLang(lang: lang);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfileInfo({
    required UpdateProfileInfoRequest request,
  }) async {
    try {
      await _remoteDataSource.updateProfileInfo(request: request);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfileImage({
    required XFile image,
  }) async {
    try {
      final user = await _remoteDataSource.updateProfileImage(image: image);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfileName({
    required String fullName,
  }) async {
    try {
      final user =
          await _remoteDataSource.updateProfileName(fullName: fullName);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfileLocation({
    required UpdateProfileLocationRequest request,
  }) async {
    try {
      final user =
          await _remoteDataSource.updateProfileLocation(request: request);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePhoneNumber({
    required String newPhoneNumber,
  }) async {
    try {
      final otp = await _remoteDataSource.updatePhoneNumber(
        newPhoneNumber: newPhoneNumber,
      );
      return Right(otp);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyUpdatePhoneNumber({
    required VerifyUpdatePhoneNumberRequest request,
  }) async {
    try {
      await _remoteDataSource.verifyUpdatePhoneNumber(request: request);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<FavoriteModel>>> getFavoriteModels() async {
    try {
      final favorites = await _remoteDataSource.getFavoriteModels();
      return Right(favorites);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFavoriteIds() async {
    try {
      final favorites = await _remoteDataSource.getFavoriteIds();
      return Right(favorites);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> addFavorite({
    required String serviceId,
  }) async {
    try {
      await _remoteDataSource.addFavorite(serviceId: serviceId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavorite({
    required String serviceId,
  }) async {
    try {
      await _remoteDataSource.removeFavorite(serviceId: serviceId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, bool>> addLike({
    required String mediaId,
  }) async {
    try {
      final isLiked = await _remoteDataSource.addLike(mediaId: mediaId);
      return Right(isLiked);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, bool>> removeLike({
    required String mediaId,
  }) async {
    try {
      final isLiked = await _remoteDataSource.removeLike(mediaId: mediaId);
      return Right(isLiked);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getLikesIds() async {
    try {
      final likes = await _remoteDataSource.getLikesIds();
      return Right(likes);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> getComments({
    required GetCommentsRequest request,
  }) async {
    try {
      final comments = await _remoteDataSource.getComments(request: request);
      return Right(comments);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, CommentModel>> addComment({
    required AddCommentRequest request,
  }) async {
    try {
      final comment = await _remoteDataSource.addComment(request: request);
      return Right(comment);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteComment({
    required String commentId,
  }) async {
    try {
      await _remoteDataSource.deleteComment(commentId: commentId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, CommentModel>> addReply({
    required AddReplyRequest request,
  }) async {
    try {
      final reply = await _remoteDataSource.addReply(request: request);
      return Right(reply);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<IssueModel>>> getIssues({
    required GetIssuesRequest request,
  }) async {
    try {
      final issues = await _remoteDataSource.getIssues(request: request);
      return Right(issues);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> createIssues({
    required CreateIssueRequest request,
  }) async {
    try {
      await _remoteDataSource.createIssues(request: request);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCommentLikesIds() async {
    try {
      final likes = await _remoteDataSource.getCommentLikesIds();
      return Right(likes);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, bool>> addCommentLike({
    required String commentId,
  }) async {
    try {
      final isLiked = await _remoteDataSource.addCommentLike(
        commentId: commentId,
      );
      return Right(isLiked);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, bool>> removeCommentLike({
    required String commentId,
  }) async {
    try {
      final isLiked = await _remoteDataSource.removeCommentLike(
        commentId: commentId,
      );
      return Right(isLiked);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, CommentModel>> updateComment(
      {required UpdateCommentRequest request}) async {
    try {
      final updateComment = await _remoteDataSource.updateComment(
        request: request,
      );
      return Right(updateComment);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> report({required ReportRequest request}) async {
    try {
      final report = await _remoteDataSource.report(
        request: request,
      );
      return Right(report);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<TieredCouponModel>>> getTieredCouponRewards() async {
    try {
      final coupons = await _remoteDataSource.getTieredCouponRewards();
      return Right(coupons);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, TieredCouponModel>> openNewRewardLevel() async {
    try {
      final coupon = await _remoteDataSource.openNewRewardLevel();
      return Right(coupon);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }
}

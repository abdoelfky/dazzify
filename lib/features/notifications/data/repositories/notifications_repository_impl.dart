import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/notifications/data/data_sources/notifications_remote_datasource.dart';
import 'package:dazzify/features/notifications/data/models/notification_model.dart';
import 'package:dazzify/features/notifications/data/repositories/notifications_repository.dart';
import 'package:dazzify/features/notifications/data/requests/get_notifications_list_request.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDatasource _remoteDatasource;

  NotificationsRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, Unit>> subscribeToNotifications({
    required String deviceToken,
  }) async {
    try {
      await _remoteDatasource.subscribeToNotifications(
          deviceToken: deviceToken);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> unSubscribeFromNotifications({
    required String deviceToken,
  }) async {
    try {
      await _remoteDatasource.unSubscribeFromNotifications(
          deviceToken: deviceToken);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotificationsList({
    required GetNotificationsListRequest request,
  }) async {
    try {
      final notifications =
          await _remoteDatasource.getNotificationsList(request: request);
      return Right(notifications);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/notifications/data/models/notification_model.dart';
import 'package:dazzify/features/notifications/data/requests/get_notifications_list_request.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, Unit>> subscribeToNotifications({
    required String deviceToken,
  });

  Future<Either<Failure, Unit>> unSubscribeFromNotifications({
    required String deviceToken,
  });

  Future<Either<Failure, List<NotificationModel>>> getNotificationsList({
    required GetNotificationsListRequest request,
  });
}

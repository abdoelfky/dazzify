import 'package:dartz/dartz.dart';
import 'package:dazzify/features/notifications/data/models/notification_model.dart';
import 'package:dazzify/features/notifications/data/requests/get_notifications_list_request.dart';

abstract class NotificationsRemoteDatasource {
  Future<Unit> subscribeToNotifications({
    required String deviceToken,
  });

  Future<Unit> unSubscribeFromNotifications({
    required String deviceToken,
  });

  Future<List<NotificationModel>> getNotificationsList({
    required GetNotificationsListRequest request,
  });
}

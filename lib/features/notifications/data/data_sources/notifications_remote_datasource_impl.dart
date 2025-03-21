import 'package:dartz/dartz.dart';
import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/features/notifications/data/data_sources/notifications_remote_datasource.dart';
import 'package:dazzify/features/notifications/data/models/notification_model.dart';
import 'package:dazzify/features/notifications/data/requests/get_notifications_list_request.dart';

class NotificationsRemoteDatasourceImpl
    implements NotificationsRemoteDatasource {
  final ApiConsumer _apiConsumer;

  NotificationsRemoteDatasourceImpl(this._apiConsumer);

  @override
  Future<Unit> subscribeToNotifications({
    required String deviceToken,
  }) async {
    return await _apiConsumer.post(
      ApiConstants.subscribeToNotification,
      body: {"device": deviceToken},
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<Unit> unSubscribeFromNotifications({
    required String deviceToken,
  }) async {
    return await _apiConsumer.delete(
      ApiConstants.unSubscribeFromNotification,
      body: {"device": deviceToken},
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<List<NotificationModel>> getNotificationsList({
    required GetNotificationsListRequest request,
  }) async {
    return await _apiConsumer.get<NotificationModel>(
      ApiConstants.userNotifications,
      queryParameters: request.toJson(),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: NotificationModel.fromJson,
    );
  }
}

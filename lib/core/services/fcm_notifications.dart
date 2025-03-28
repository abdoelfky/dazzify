import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/notification_type_enum.dart';
import 'package:dazzify/firebase_options.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:injectable/injectable.dart';
import 'package:mwidgets/mwidgets.dart';

abstract class FCMNotification {
  Future<String> getFCMToken();

  Future<void> init();

  void onClick({required RemoteMessage message});

  void onReceived({required RemoteMessage message});
}

@pragma('vm:entry-point')
Future<void> onMessagingBackground(RemoteMessage message) async {
  await FCMConfig.instance.local.displayNotificationFrom(
    message,
    (androidNotificationDetails, remoteMessage) async {
      return androidNotificationDetails;
    },
    (darwinNotificationDetails, remoteMessage) async {
      return darwinNotificationDetails;
    },
    (darwinNotificationDetails, remoteMessage) async {
      return darwinNotificationDetails;
    },
  );
}

@LazySingleton(as: FCMNotification)
class FCMNotificationImpl extends FCMNotification {
  final AppRouter appRouter;

  FCMNotificationImpl(this.appRouter);

  @override
  Future<String> getFCMToken() async {
    String? token = '';
    token = await FCMConfig.instance.messaging.getToken();
    kPrint('FCMToken : $token');
    print('object');
    print(token);
    return token ?? '';
  }

  @override
  Future<void> init() async {

      await FCMConfig.instance.init(
      options: DefaultFirebaseOptions.currentPlatform,
      onBackgroundMessage: onMessagingBackground,

      defaultAndroidChannel: const AndroidNotificationChannel(
        'Dazzify Notifications',
        'Dazzify Notifications',
        description:
            "Get latest notifications about Dazzify's offers and messages",
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('sound_alert'),
      ),

      // options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      onDataReceive(event.data);
      kPrint(event.data);
    });
    getFCMToken();
  }

  @override
  Future<void> onClick({required RemoteMessage message}) async {}

  @override
  Future<void> onReceived({required RemoteMessage message}) async {
    final notificationType = getNotificationType(message.data['type']);

    switch (notificationType) {
      case NotificationTypeEnum.payment:
        appRouter.navigate(
          const ProfileTabRoute(
            children: [
              ProfileRoute(),
              PaymentRoutes(children: [TransactionRoute()]),
            ],
          ),
        );
        break;
      case NotificationTypeEnum.bookingStatus:
        appRouter.navigate(
          const ProfileTabRoute(
            children: [ProfileRoute(), BookingsHistoryRoute()],
          ),
        );
        break;
      default:
        appRouter.navigate(const NotificationsRoute());
    }
    kPrint(message.notification);
    kPrint(message.data);
  }
}

void onDataReceive(Map<String, dynamic> data) {}

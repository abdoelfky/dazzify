import 'package:fcm_config/fcm_config.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/firebase_options.dart';
import 'package:injectable/injectable.dart';
import 'package:mwidgets/mwidgets.dart';

abstract class FCMNotification {
  Future<String> getFCMToken();
  Future<void> init();
  void onClick({required RemoteMessage message});
  // void onReceived({required RemoteMessage message});
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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  FCMNotificationImpl(this.appRouter);

  @override
  Future<String> getFCMToken() async {
    String? token = '';
    token = await FCMConfig.instance.messaging.getToken();
    kPrint('FCMToken : $token');
    return token ?? '';
  }

  @override
  Future<void> init() async {
    // Initialize FCMConfig
    await FCMConfig.instance.init(
      options: DefaultFirebaseOptions.currentPlatform,
      onBackgroundMessage: onMessagingBackground,
      defaultAndroidChannel: const AndroidNotificationChannel(
        'Dazzify Notifications',
        'Dazzify Notifications',
        description:
        "Get the latest notifications about Dazzify's offers and messages",
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('sound_alert'),
      ),
    );

    // Initialize the Flutter local notifications plugin
    // _initializeLocalNotifications();

    // Request notification permission for iOS
    // _requestNotificationPermission();

    // Trigger a dummy notification when the app is opened
    // _showDummyNotification();

    // Listen for when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      onDataReceive(event.data);
      kPrint(event.data);
    });
  }

  // Initialize the Flutter Local Notifications Plugin
  void _initializeLocalNotifications() {

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Request notification permission for iOS
  void _requestNotificationPermission() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS (only necessary for iOS devices)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications");
    } else {
      print("User declined permission for notifications");
    }
  }

  // Show a dummy notification when the app is opened

  // void _showDummyNotification() async {
  //   print('_showDummyNotification');
  //
  //   const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
  //     'dummy_channel_id',
  //     'Dummy Notifications',
  //     channelDescription: 'This is a dummy notification for app open',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );
  //
  //   const DarwinNotificationDetails iOSNotificationDetails = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //
  //   const NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: iOSNotificationDetails,
  //   );
  //
  //   // Show a dummy notification
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Welcome to Dazzify!',
  //     'This is a dummy notification triggered when the app is opened.',
  //     platformChannelSpecifics,
  //     payload: 'Dummy notification payload',
  //   );
  // }

  @override
  Future<void> onClick({required RemoteMessage message}) async {}

//   @override
//   Future<void> onReceived({required RemoteMessage message}) async {
//     final notificationType = getNotificationType(message.data['type']);
//
//     switch (notificationType) {
//       case NotificationTypeEnum.payment:
//         appRouter.navigate(
//           const ProfileTabRoute(
//             children: [
//               ProfileRoute(),
//               PaymentRoutes(children: [TransactionRoute()]),
//             ],
//           ),
//         );
//         break;
//       case NotificationTypeEnum.bookingStatus:
//         appRouter.navigate(
//           const ProfileTabRoute(
//             children: [ProfileRoute(), BookingsHistoryRoute()],
//           ),
//         );
//         break;
//       default:
//         appRouter.navigate(const NotificationsRoute());
//     }
//     kPrint(message.notification);
//     kPrint(message.data);
//   }
}

void onDataReceive(Map<String, dynamic> data) {}

import 'dart:convert';
import 'package:dazzify/core/util/notification_type_enum.dart';
import 'package:dazzify/features/chat/presentation/screens/chat_screen.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/firebase_options.dart';
import 'package:injectable/injectable.dart';
import 'package:mwidgets/mwidgets.dart';

abstract class FCMNotification {
  Future<String> getFCMToken();

  Future<void> init();

  void onClick({required RemoteMessage message});

  Future<void> onReceived({required RemoteMessage message});

  Future<void> clearAllNotifications();
}

@pragma('vm:entry-point')
Future<void> onMessagingBackground(RemoteMessage message) async {
  final android = AndroidNotificationDetails(
    'Dazzify Notifications',
    'Dazzify Notifications',
    channelDescription:
        "Get the latest notifications about Dazzify's offers and messages",
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('sound_alert'),
    // Always show full notification body
    styleInformation: BigTextStyleInformation(
      message.notification?.body ?? '',
      contentTitle: message.notification?.title ?? '',
    ),
  );

  final ios = DarwinNotificationDetails(
    interruptionLevel: InterruptionLevel.timeSensitive,
    presentAlert: true,
    presentSound: true,
    presentBadge: true,
  );

  final notificationDetails = NotificationDetails(
    android: android,
    iOS: ios,
  );

  await FlutterLocalNotificationsPlugin().show(
    message.hashCode,
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    notificationDetails,
    payload: jsonEncode(message.data), // ✅ THIS is where payload goes
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
    final token = await FCMConfig.instance.messaging.getToken();
    kPrint('✅ [FCMToken] => $token');
    return token ?? '';
  }

  @override
  Future<void> init() async {
    kPrint('🔧 Initializing FCMConfig...');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    // Initialize FCM with foreground notification display enabled for iOS
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

    // Initialize local notifications plugin and handle notification taps
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);
          kPrint('📲 Local notification tapped: $data');
          final message = RemoteMessage(data: data);
          await onReceived(message: message);
        }
      },
    );

    kPrint('✅ FCMConfig & Notification Plugin initialized.');

    // Handle notification when tapped from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      kPrint('📬 onMessageOpenedApp triggered.');
      kPrint('🔍 Notification Data: ${message.data}');
      await onReceived(message: message);
    });

    // Handle notification when app is launched from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      kPrint('📦 App opened from terminated state via notification.');
      kPrint('🔍 Initial Notification Data: ${initialMessage.data}');
      await onReceived(message: initialMessage);
    }
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void onClick({required RemoteMessage message}) {
    kPrint('🖱️ Notification Clicked: ${message.data}');
  }

  @override
  Future<void> onReceived({required RemoteMessage message}) async {
    try {
      kPrint('📦 Full RemoteMessage:');
      kPrint('  Message ID: ${message.messageId}');
      kPrint('  From: ${message.from}');
      kPrint('  Sent Time: ${message.sentTime}');
      kPrint('  Data: ${message.data}');
      kPrint(
          '  Notification: ${message.notification?.title} - ${message.notification?.body}');

      // ✅ Check for nested 'data' key
      dynamic type;
      if (message.data.containsKey('data')) {
        final nestedData = message.data['data'];
        if (nestedData is Map && nestedData.containsKey('type')) {
          type = nestedData['type'];
        }
      } else if (message.data.containsKey('type')) {
        type = message.data['type'];
      }

      if (type == null) {
        kPrint('⚠️ Notification type is null — skipping routing.');
        return;
      }

      final notificationType = getNotificationType(type.toString());

      switch (notificationType) {
        case NotificationTypeEnum.payment:
          kPrint('➡️ Navigating to Payment screen...');
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
          kPrint('➡️ Navigating to Booking History...');
          appRouter.navigate(
            const ProfileTabRoute(
              children: [ProfileRoute(), BookingsHistoryRoute()],
            ),
          );
          break;
        case NotificationTypeEnum.general:
          kPrint('➡️ Navigating to Home Screen ...');
          appRouter.navigate(
            const HomeRoute(),
          );
          break;
        case NotificationTypeEnum.newMessage:
          kPrint('➡️ Navigating to Messages ...');
          appRouter.navigate(
            const ConversationsRoute(),
          );
          break;
        case NotificationTypeEnum.issueStatus:
          kPrint('➡️ Navigating to issues ...');
          appRouter.navigate(
            const IssueRoute(),
          );
          break;

        default:
          kPrint('➡️ Navigating to Notifications screen (default)...');
          appRouter.navigate(const NotificationsRoute());
      }

      kPrint('✅ Navigation complete.');
    } catch (e, stack) {
      kPrint('❌ Error handling notification: $e');
      kPrint(stack.toString());
    }
  }

  void onDataReceive(Map<String, dynamic> data) {
    kPrint('📨 onDataReceive called with: $data');
    final message = RemoteMessage(data: data);
    onReceived(message: message);
  }

  @override
  Future<void> clearAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      kPrint('✅ All notifications cleared successfully.');
    } catch (e) {
      kPrint('❌ Error clearing notifications: $e');
    }
  }
}

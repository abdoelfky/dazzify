// import 'dart:io';
//
// import 'package:dazzify/core/constants/app_constants.dart';
// import 'package:dazzify/core/injection/injection.dart';
// import 'package:dazzify/core/util/notification_type_enum.dart';
// import 'package:dazzify/features/notifications/logic/app_notifications/app_notifications_cubit.dart';
// import 'package:dazzify/firebase_options.dart';
// import 'package:dazzify/main.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:rxdart/rxdart.dart';
//
// class NotificationsService {
//   static final _instance = NotificationsService._internal();
//   factory NotificationsService() => _instance;
//   NotificationsService._internal();
//
//   static final _localNotifications = FlutterLocalNotificationsPlugin();
//   static final onClickNotification = BehaviorSubject<NotificationResponse>();
//   static final _onReceiveNotification = BehaviorSubject<RemoteMessage>();
//   static final _appNotificationsCubit = getIt<AppNotificationsCubit>();
//
//   static final _processedNotifications = <String>{};
//   static final _processedTaps = <String>{};
//   static const _maxProcessedEntries = 100;
//   static bool isInitialized = false;
//
//   /// Initializes Firebase and sets up notifications
//   static Future<void> init() async {
//     if (isInitialized) return;
//     try {
//       isInitialized = true;
//       await Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform);
//       await _initializeNotifications();
//     } catch (e) {
//       debugPrint('Error initializing NotificationsService: $e');
//       isInitialized = false;
//       rethrow;
//     }
//   }
//
//   static Future<void> _initializeNotifications() async {
//     await _setupFirebaseMessaging();
//     await _setupLocalNotifications();
//     await _handleInitialNotification();
//     _setupNotificationListeners();
//   }
//
//   /// Ensures APNS token is available before fetching FCM token on iOS
//   static Future<void> _setupFirebaseMessaging() async {
//     if (Platform.isIOS && !kDebugMode) {
//       String? apnsToken;
//       int retries = 10;
//
//       while (retries > 0) {
//         apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//         if (apnsToken != null) break;
//
//         await Future.delayed(const Duration(milliseconds: 500));
//         retries--;
//       }
//
//       if (apnsToken != null) {
//         debugPrint("APNS Token: $apnsToken");
//       } else {
//         debugPrint("Failed to retrieve APNS Token after multiple attempts.");
//       }
//     }
//
//     // Subscribe to topic only if not running on iOS in debug mode
//     if (!(Platform.isIOS && kDebugMode)) {
//       await FirebaseMessaging.instance
//           .subscribeToTopic(AppConstants.generalNotificationsTopic);
//     }
//
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.instance.onTokenRefresh
//         .listen((_) => _appNotificationsCubit.subscribeToNotifications());
//   }
//
//   static Future<void> _setupLocalNotifications() async {
//     await _localNotifications.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//         iOS: DarwinInitializationSettings(
//           requestSoundPermission: true,
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//         ),
//       ),
//       onDidReceiveNotificationResponse: _onNotificationTap,
//       onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
//     );
//   }
//
//   static Future<void> _handleInitialNotification() async {
//     final details = await _localNotifications.getNotificationAppLaunchDetails();
//     if (details?.didNotificationLaunchApp ?? false) {
//       _onNotificationTap(details!.notificationResponse!);
//     }
//   }
//
//   static void _setupNotificationListeners() {
//     FirebaseMessaging.onMessage.listen(_handleForegroundNotification);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundNotification);
//   }
//
//   static Future<void> _handleForegroundNotification(
//       RemoteMessage message) async {
//     if (shouldProcessNotification(message)) {
//       _onReceiveNotification.add(message);
//       if (getNotificationType(message.data['type']) !=
//           NotificationTypeEnum.ban) {
//         await showNotification(message);
//       }
//     }
//   }
//
//   static Future<void> _handleBackgroundNotification(
//       RemoteMessage message) async {
//     if (shouldProcessNotification(message)) {
//       _onReceiveNotification.add(message);
//       await showNotification(message);
//     }
//   }
//
//   static bool shouldProcessNotification(RemoteMessage message) {
//     final messageId = message.messageId ?? '';
//     if (_processedNotifications.contains(messageId)) return false;
//     _processedNotifications.add(messageId);
//     if (_processedNotifications.length > _maxProcessedEntries) {
//       _processedNotifications.clear();
//     }
//     return true;
//   }
//
//   static void _onNotificationTap(NotificationResponse response) {
//     final tapId = '${response.id}_${response.payload}';
//     if (_processedTaps.contains(tapId)) return;
//     _processedTaps.add(tapId);
//     if (_processedTaps.length > _maxProcessedEntries) {
//       _processedTaps.clear();
//     }
//     onClickNotification.add(response);
//   }
//
//   static Future<void> requestPermissions() async {
//     if (Platform.isIOS) {
//       await _localNotifications
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//               alert: true, badge: true, sound: true, critical: true);
//     } else {
//       await _localNotifications
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.requestNotificationsPermission();
//     }
//   }
//
//   /// Ensures APNS token is available before getting the FCM token (for iOS)
//   static Future<String?> getDeviceToken() async {
//     if (Platform.isIOS && !kDebugMode) {
//       String? apnsToken;
//       int retries = 10;
//
//       while (retries > 0) {
//         apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//         if (apnsToken != null) break;
//
//         await Future.delayed(const Duration(milliseconds: 500));
//         retries--;
//       }
//
//       if (apnsToken != null) {
//         debugPrint("APNS Token: $apnsToken");
//       } else {
//         debugPrint("Failed to retrieve APNS Token after multiple attempts.");
//       }
//     }
//
//     final token = await FirebaseMessaging.instance.getToken();
//     debugPrint("FCM Token: $token");
//     return token;
//   }
//
//   static Future<void> showNotification(RemoteMessage message) async {
//     try {
//       final notificationDetails = await _getNotificationDetails(message);
//       await _localNotifications.show(
//         message.hashCode,
//         message.data['title'],
//         message.data['body'],
//         notificationDetails,
//         payload: message.data['type'],
//       );
//     } catch (e) {
//       debugPrint('Error showing notification: $e');
//     }
//   }
//
//   static Future<NotificationDetails> _getNotificationDetails(
//       RemoteMessage message) async {
//     final imageUrl = message.data['imageUrl'];
//     BigPictureStyleInformation? bigPictureStyle;
//     DarwinNotificationDetails? iosDetails;
//
//     if (imageUrl != null) {
//       final response = await http.get(Uri.parse(imageUrl));
//       final filePath = '${Directory.systemTemp.path}/notificationImage';
//       final file = File(filePath)..writeAsBytesSync(response.bodyBytes);
//
//       bigPictureStyle = BigPictureStyleInformation(
//         FilePathAndroidBitmap(file.path),
//         contentTitle: message.data['title'],
//         summaryText: message.data['body'],
//       );
//       iosDetails = DarwinNotificationDetails(
//         attachments: [DarwinNotificationAttachment(file.path)],
//       );
//     }
//
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         'Dazzify Notifications',
//         'Dazzify Notifications',
//         channelDescription:
//             "Get latest notifications about Dazzify's offers and messages",
//         importance: Importance.max,
//         priority: Priority.high,
//         styleInformation: bigPictureStyle,
//         groupKey: 'com.dazzify.app.notifications',
//       ),
//       iOS: iosDetails ?? const DarwinNotificationDetails(),
//     );
//   }
//
//   static Future<void> clearNotifications() async {
//     await _localNotifications.cancelAll();
//     _processedNotifications.clear();
//     _processedTaps.clear();
//   }
//
//   static Future<void> close() async {
//     await clearNotifications();
//     _onReceiveNotification.close();
//     onClickNotification.close();
//     await FirebaseMessaging.instance
//         .unsubscribeFromTopic(AppConstants.generalNotificationsTopic);
//     isInitialized = false;
//   }
// }

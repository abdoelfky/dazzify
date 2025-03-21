import 'dart:io';

import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/fcm_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static Future<Device> getInfo() async {
    String name = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      name = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      name = iosInfo.name;
    }
    return Device(
      id: name,
      type: Platform.isIOS ? 2 : 1,
      fcmToken: "${await _getToken()}",
    );
  }

  static Future<String?> _getToken() async {
    try {
      return await getIt<FCMNotification>().getFCMToken();
    } catch (e) {
      return '';
    }
  }
}

class Device {
  final String id;
  final int type;
  final String fcmToken;

  Device({
    required this.id,
    required this.type,
    required this.fcmToken,
  });
}

import 'package:dazzify/features/auth/data/models/app_config_model.dart';

class AppConfigManager {
  static AppConfigModel? _config;

  static set config(AppConfigModel value) => _config = value;

  static AppConfigModel get config {
    if (_config == null) {
      throw Exception('AppConfigManager.config is not initialized yet');
    }
    return _config!;
  }

  static bool get isInitialized => _config != null;

  // App Fees
  static int get appFeesMax => config.appFees.max;
  static int get appFeesMin => config.appFees.min;
  static double get appFeesPercentage => config.appFees.percentage;

  // App State
  static bool get isAppInMaintenance => config.appInMaintenance;
  static bool get isGuestMode => config.guestMode;

  // Guest Token
  static String get guestToken => config.guestToken ?? '';
  static DateTime? get guestTokenExpireTime => config.guestTokenExpireTime;

  // Versioning
  static String get iosVersion => config.appVersion.ios;
  static String get androidVersion => config.appVersion.android;
  static bool get forceUpdate => config.appVersion.forceUpdate;

  // ✅ Download Links
  static String get iosDownloadLink => config.appVersion.iosDownloadLink;
  static String get androidDownloadLink => config.appVersion.androidDownloadLink;
}

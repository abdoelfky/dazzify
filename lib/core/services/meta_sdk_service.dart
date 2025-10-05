import 'package:flutter_meta_sdk/flutter_meta_sdk.dart';

/// Service class to manage Meta SDK (Facebook SDK) integration
/// This service tracks app install events for Meta Analytics
class MetaSdkService {
  MetaSdkService._();
  static final MetaSdkService instance = MetaSdkService._();

  final _metaSdk = FlutterMetaSdk();

  /// Initialize Meta SDK and track app install
  /// Should be called once during app initialization
  Future<void> initialize() async {
    try {
      // Track app install event
      await logAppInstall();
    } catch (e) {
      // Log error but don't crash the app
      print('Meta SDK initialization error: $e');
    }
  }

  /// Log app install event
  /// This tracks when user opens the app after installation
  Future<void> logAppInstall() async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_first_time_purchase',
        parameters: {
          'fb_mobile_launch_source': 'Organic',
        },
      );
    } catch (e) {
      print('Meta SDK log app install error: $e');
    }
  }
}

import 'package:flutter/services.dart';

/// Service class to manage TikTok SDK integration
/// This service tracks app events and conversions for TikTok Analytics
class TikTokSdkService {
  TikTokSdkService._();
  static final TikTokSdkService instance = TikTokSdkService._();

  static const MethodChannel _channel = MethodChannel('com.dazzify.app/tiktok');
  bool _isInitialized = false;

  /// Initialize TikTok SDK
  /// Should be called once during app initialization
  Future<void> initialize() async {
    try {
      final result = await _channel.invokeMethod('initialize');
      _isInitialized = result == true;
      
      if (_isInitialized) {
        // Track app install event
        await logAppInstall();
      }
    } catch (e) {
      // Log error but don't crash the app
      print('TikTok SDK initialization error: $e');
    }
  }

  /// Log app install event
  /// This tracks when user opens the app after installation
  Future<void> logAppInstall() async {
    try {
      await logEvent(
        eventName: 'AppInstall',
        parameters: {
          'event_type': 'app_install',
          'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
      );
    } catch (e) {
      print('TikTok SDK log app install error: $e');
    }
  }

  /// Log app launch event
  Future<void> logAppLaunch() async {
    try {
      await logEvent(
        eventName: 'LaunchAPP',
        parameters: {
          'event_type': 'app_launch',
          'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
      );
    } catch (e) {
      print('TikTok SDK log app launch error: $e');
    }
  }

  /// Log registration event
  Future<void> logRegistration({
    required String method,
  }) async {
    try {
      await logEvent(
        eventName: 'Registration',
        parameters: {
          'event_type': 'registration',
          'registration_method': method,
          'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
      );
    } catch (e) {
      print('TikTok SDK log registration error: $e');
    }
  }

  /// Log purchase event
  Future<void> logPurchase({
    required double value,
    required String currency,
    String? contentId,
    String? contentName,
  }) async {
    try {
      await logEvent(
        eventName: 'Purchase',
        parameters: {
          'event_type': 'purchase',
          'value': value,
          'currency': currency,
          if (contentId != null) 'content_id': contentId,
          if (contentName != null) 'content_name': contentName,
          'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
      );
    } catch (e) {
      print('TikTok SDK log purchase error: $e');
    }
  }

  /// Log view content event
  Future<void> logViewContent({
    required String contentId,
    String? contentName,
    String? contentCategory,
  }) async {
    try {
      await logEvent(
        eventName: 'ViewContent',
        parameters: {
          'event_type': 'view_content',
          'content_id': contentId,
          if (contentName != null) 'content_name': contentName,
          if (contentCategory != null) 'content_category': contentCategory,
          'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
      );
    } catch (e) {
      print('TikTok SDK log view content error: $e');
    }
  }

  /// Log add to cart event
  Future<void> logAddToCart({
    required String contentId,
    String? contentName,
    double? value,
    String? currency,
  }) async {
    try {
      await logEvent(
        eventName: 'AddToCart',
        parameters: {
          'event_type': 'add_to_cart',
          'content_id': contentId,
          if (contentName != null) 'content_name': contentName,
          if (value != null) 'value': value,
          if (currency != null) 'currency': currency,
          'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
      );
    } catch (e) {
      print('TikTok SDK log add to cart error: $e');
    }
  }

  /// Log checkout event
  Future<void> logCheckout({
    double? value,
    String? currency,
    List<String>? contentIds,
  }) async {
    try {
      await logEvent(
        eventName: 'InitiateCheckout',
        parameters: {
          'event_type': 'checkout',
          if (value != null) 'value': value,
          if (currency != null) 'currency': currency,
          if (contentIds != null) 'content_ids': contentIds,
          'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        },
      );
    } catch (e) {
      print('TikTok SDK log checkout error: $e');
    }
  }

  /// Generic event logging method
  Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized) {
      print('TikTok SDK not initialized');
      return;
    }

    try {
      await _channel.invokeMethod('logEvent', {
        'eventName': eventName,
        'parameters': parameters ?? {},
      });
      print('TikTok Event logged: $eventName');
    } catch (e) {
      print('TikTok SDK log event error: $e');
    }
  }
}

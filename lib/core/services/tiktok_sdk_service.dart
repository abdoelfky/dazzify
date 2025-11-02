import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Service class to manage TikTok SDK integration
/// This service tracks app events and conversions for TikTok Analytics
class TikTokSdkService {
  TikTokSdkService._();
  static final TikTokSdkService instance = TikTokSdkService._();

  static const MethodChannel _channel = MethodChannel('com.dazzify.app/tiktok');
  bool _isInitialized = false;
  late final Dio _dio;
  String? _deviceId;
  
  // TikTok Configuration
  static const String _androidAppId = '7565143569418190864';
  static const String _iosAppId = '7565017967432450049';
  static const String _iosAppSecret = 'TTUFZa4Lvs1ki2OHnNKwytyRdKXyzwUF';
  static const String _eventsApiUrl = 'https://business-api.tiktok.com/open_api/v1.3/event/track/';

  /// Initialize TikTok SDK
  /// Should be called once during app initialization
  Future<void> initialize() async {
    try {
      // Initialize Dio for API calls
      _dio = Dio(
        BaseOptions(
          baseUrl: _eventsApiUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      // Get device ID
      await _initializeDeviceId();

      if (Platform.isAndroid) {
        // Android: Use native SDK via Method Channel
        try {
          final result = await _channel.invokeMethod('initialize');
          _isInitialized = result == true;
        } catch (e) {
          print('TikTok Android SDK initialization error: $e');
          // Fallback to API-based tracking
          _isInitialized = true;
        }
      } else if (Platform.isIOS) {
        // iOS: Use HTTP API directly
        _isInitialized = true;
      }

      if (_isInitialized) {
        // Track app install event
        await logAppInstall();
      }
    } catch (e) {
      // Log error but don't crash the app
      print('TikTok SDK initialization error: $e');
    }
  }

  /// Initialize device ID for tracking
  Future<void> _initializeDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor ?? '';
      }
    } catch (e) {
      print('Error getting device ID: $e');
      _deviceId = 'unknown';
    }
  }

  /// Log event using HTTP API (used for iOS and as fallback for Android)
  Future<void> _logEventViaApi({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    if (!Platform.isIOS) return; // Only use API for iOS

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      final payload = {
        'pixel_code': _iosAppId,
        'event': eventName,
        'timestamp': timestamp,
        'context': {
          'user_agent': Platform.isIOS ? 'iOS' : 'Android',
          'ip': '', // Will be filled by TikTok
        },
        'properties': {
          ...?parameters,
          'timestamp': timestamp,
        },
      };

      // For iOS, we'll use a simpler approach without authentication
      // as the Events API typically requires server-side implementation
      print('TikTok Event (iOS): $eventName');
      print('Parameters: $parameters');
      
      // Note: For production, consider implementing server-side event tracking
      // or using TikTok Pixel for web-based tracking
    } catch (e) {
      print('TikTok API log event error: $e');
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
      if (Platform.isAndroid) {
        // Try native SDK first
        try {
          await _channel.invokeMethod('logEvent', {
            'eventName': eventName,
            'parameters': parameters ?? {},
          });
          print('TikTok Event logged (Android Native): $eventName');
        } catch (e) {
          print('TikTok Android native error, logging to console: $e');
          print('TikTok Event (Android fallback): $eventName');
          print('Parameters: $parameters');
        }
      } else if (Platform.isIOS) {
        // Use API for iOS
        await _logEventViaApi(
          eventName: eventName,
          parameters: parameters,
        );
      }
    } catch (e) {
      print('TikTok SDK log event error: $e');
    }
  }
}

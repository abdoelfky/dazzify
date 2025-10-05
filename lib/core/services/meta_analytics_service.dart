import 'package:flutter_meta_sdk/flutter_meta_sdk.dart';
import 'package:injectable/injectable.dart';
import 'package:mwidgets/mwidgets.dart';

/// Meta Analytics Service for tracking Facebook/Instagram events
/// This service wraps the Meta SDK to track app events and conversions
abstract class MetaAnalyticsService {
  /// Initialize the Meta SDK
  Future<void> init();

  /// Log a standard event
  Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  });

  /// Log when a user adds payment info
  Future<void> logAddPaymentInfo({
    required double value,
    required String currency,
  });

  /// Log when a user completes registration
  Future<void> logCompleteRegistration({
    String? registrationMethod,
  });

  /// Log when a user initiates checkout
  Future<void> logInitiateCheckout({
    required double value,
    required String currency,
    required String contentType,
    required String contentId,
  });

  /// Log when a purchase is completed
  Future<void> logPurchase({
    required double amount,
    required String currency,
    required String contentType,
    required String contentId,
  });

  /// Log when a user views content
  Future<void> logViewContent({
    required String contentType,
    required String contentId,
    String? contentName,
    double? value,
    String? currency,
  });

  /// Log when a user searches
  Future<void> logSearch({
    required String searchString,
    String? contentType,
  });

  /// Log when a user adds to cart
  Future<void> logAddToCart({
    required double value,
    required String currency,
    required String contentType,
    required String contentId,
  });

  /// Log when a user adds to wishlist
  Future<void> logAddToWishlist({
    required String contentId,
    String? contentName,
    double? value,
    String? currency,
  });

  /// Log a custom event for ad creation (specific to dashboard)
  Future<void> logAdCreation({
    required String platform, // 'facebook' or 'instagram'
    required String adType,
    String? brandId,
    String? serviceId,
  });
}

@LazySingleton(as: MetaAnalyticsService)
class MetaAnalyticsServiceImpl implements MetaAnalyticsService {
  bool _isInitialized = false;

  @override
  Future<void> init() async {
    try {
      kPrint('🔧 Initializing Meta SDK...');
      
      // Initialize the Meta SDK
      await FlutterMetaSdk.initialize();
      
      // Enable automatic event logging
      await FlutterMetaSdk.setAutoLogAppEventsEnabled(true);
      
      // Enable advertiser tracking (important for iOS)
      await FlutterMetaSdk.setAdvertiserTrackingEnabled(true);
      
      _isInitialized = true;
      kPrint('✅ Meta SDK initialized successfully');
    } catch (e, stack) {
      kPrint('❌ Error initializing Meta SDK: $e');
      kPrint(stack.toString());
    }
  }

  @override
  Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized) {
      kPrint('⚠️ Meta SDK not initialized. Call init() first.');
      return;
    }

    try {
      await FlutterMetaSdk.logEvent(
        eventName: eventName,
        parameters: parameters ?? {},
      );
      kPrint('📊 Meta Event Logged: $eventName with params: $parameters');
    } catch (e) {
      kPrint('❌ Error logging Meta event: $e');
    }
  }

  @override
  Future<void> logAddPaymentInfo({
    required double value,
    required String currency,
  }) async {
    await logEvent(
      eventName: 'AddPaymentInfo',
      parameters: {
        'fb_currency': currency,
        'fb_value': value,
      },
    );
  }

  @override
  Future<void> logCompleteRegistration({
    String? registrationMethod,
  }) async {
    await logEvent(
      eventName: 'CompleteRegistration',
      parameters: {
        if (registrationMethod != null)
          'fb_registration_method': registrationMethod,
      },
    );
  }

  @override
  Future<void> logInitiateCheckout({
    required double value,
    required String currency,
    required String contentType,
    required String contentId,
  }) async {
    await logEvent(
      eventName: 'InitiateCheckout',
      parameters: {
        'fb_currency': currency,
        'fb_value': value,
        'fb_content_type': contentType,
        'fb_content_id': contentId,
      },
    );
  }

  @override
  Future<void> logPurchase({
    required double amount,
    required String currency,
    required String contentType,
    required String contentId,
  }) async {
    await logEvent(
      eventName: 'Purchase',
      parameters: {
        'fb_currency': currency,
        'fb_value': amount,
        'fb_content_type': contentType,
        'fb_content_id': contentId,
      },
    );
  }

  @override
  Future<void> logViewContent({
    required String contentType,
    required String contentId,
    String? contentName,
    double? value,
    String? currency,
  }) async {
    await logEvent(
      eventName: 'ViewContent',
      parameters: {
        'fb_content_type': contentType,
        'fb_content_id': contentId,
        if (contentName != null) 'fb_content_name': contentName,
        if (value != null) 'fb_value': value,
        if (currency != null) 'fb_currency': currency,
      },
    );
  }

  @override
  Future<void> logSearch({
    required String searchString,
    String? contentType,
  }) async {
    await logEvent(
      eventName: 'Search',
      parameters: {
        'fb_search_string': searchString,
        if (contentType != null) 'fb_content_type': contentType,
      },
    );
  }

  @override
  Future<void> logAddToCart({
    required double value,
    required String currency,
    required String contentType,
    required String contentId,
  }) async {
    await logEvent(
      eventName: 'AddToCart',
      parameters: {
        'fb_currency': currency,
        'fb_value': value,
        'fb_content_type': contentType,
        'fb_content_id': contentId,
      },
    );
  }

  @override
  Future<void> logAddToWishlist({
    required String contentId,
    String? contentName,
    double? value,
    String? currency,
  }) async {
    await logEvent(
      eventName: 'AddToWishlist',
      parameters: {
        'fb_content_id': contentId,
        if (contentName != null) 'fb_content_name': contentName,
        if (value != null) 'fb_value': value,
        if (currency != null) 'fb_currency': currency,
      },
    );
  }

  @override
  Future<void> logAdCreation({
    required String platform,
    required String adType,
    String? brandId,
    String? serviceId,
  }) async {
    await logEvent(
      eventName: 'AdCreated',
      parameters: {
        'platform': platform, // 'facebook' or 'instagram'
        'ad_type': adType,
        if (brandId != null) 'brand_id': brandId,
        if (serviceId != null) 'service_id': serviceId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}

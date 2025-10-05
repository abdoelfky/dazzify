
import 'package:flutter_meta_sdk/flutter_meta_sdk.dart';

/// Service class to manage Meta SDK (Facebook SDK) integration
/// This service provides methods to track app events for Meta Analytics and Conversion API
class MetaSdkService {
  MetaSdkService._();
  static final MetaSdkService instance = MetaSdkService._();

  final _metaSdk = FlutterMetaSdk();

  /// Initialize Meta SDK
  /// Should be called once during app initialization
  Future<void> initialize() async {
    try {
      await _metaSdk.initialize();
      // Log app activation when SDK initializes
      await logAppActivated();
    } catch (e) {
      // Log error but don't crash the app
      print('Meta SDK initialization error: $e');
    }
  }

  /// Log app activation event
  /// This is automatically tracked when the app is opened
  Future<void> logAppActivated() async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_activate_app',
        parameters: {},
      );
    } catch (e) {
      print('Meta SDK log app activated error: $e');
    }
  }

  /// Log app install event
  /// This should be called the first time user opens the app after installation
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

  /// Log completed registration event
  /// Call this when user completes registration/sign up
  Future<void> logCompletedRegistration({
    String? registrationMethod,
  }) async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_complete_registration',
        parameters: {
          if (registrationMethod != null)
            'fb_registration_method': registrationMethod,
        },
      );
    } catch (e) {
      print('Meta SDK log completed registration error: $e');
    }
  }

  /// Log purchase event
  /// Call this when user completes a purchase
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_purchase',
        parameters: {
          'fb_currency': currency,
          'fb_content_type': 'product',
          '_valueToSum': amount,
          ...?additionalParams,
        },
      );
    } catch (e) {
      print('Meta SDK log purchase error: $e');
    }
  }

  /// Log content view event
  /// Call this when user views specific content
  Future<void> logContentView({
    required String contentType,
    required String contentId,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_content_view',
        parameters: {
          'fb_content_type': contentType,
          'fb_content_id': contentId,
          ...?additionalParams,
        },
      );
    } catch (e) {
      print('Meta SDK log content view error: $e');
    }
  }

  /// Log search event
  /// Call this when user performs a search
  Future<void> logSearch({
    required String searchString,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_search',
        parameters: {
          'fb_search_string': searchString,
          ...?additionalParams,
        },
      );
    } catch (e) {
      print('Meta SDK log search error: $e');
    }
  }

  /// Log add to cart event
  /// Call this when user adds item to cart
  Future<void> logAddToCart({
    required String contentId,
    required String contentType,
    required double price,
    required String currency,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_add_to_cart',
        parameters: {
          'fb_content_id': contentId,
          'fb_content_type': contentType,
          'fb_currency': currency,
          '_valueToSum': price,
          ...?additionalParams,
        },
      );
    } catch (e) {
      print('Meta SDK log add to cart error: $e');
    }
  }

  /// Log add to wishlist event
  /// Call this when user adds item to wishlist
  Future<void> logAddToWishlist({
    required String contentId,
    required String contentType,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_add_to_wishlist',
        parameters: {
          'fb_content_id': contentId,
          'fb_content_type': contentType,
          ...?additionalParams,
        },
      );
    } catch (e) {
      print('Meta SDK log add to wishlist error: $e');
    }
  }

  /// Log initiated checkout event
  /// Call this when user starts checkout process
  Future<void> logInitiatedCheckout({
    required int numItems,
    required double totalPrice,
    required String currency,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      await _metaSdk.logEvent(
        name: 'fb_mobile_initiated_checkout',
        parameters: {
          'fb_num_items': numItems,
          'fb_currency': currency,
          '_valueToSum': totalPrice,
          ...?additionalParams,
        },
      );
    } catch (e) {
      print('Meta SDK log initiated checkout error: $e');
    }
  }

  /// Log custom event with custom parameters
  /// Use this for events not covered by the predefined methods
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _metaSdk.logEvent(
        name: eventName,
        parameters: parameters ?? {},
      );
    } catch (e) {
      print('Meta SDK log custom event error: $e');
    }
  }

  /// Set user ID for tracking
  /// Call this after user logs in
  Future<void> setUserId(String userId) async {
    try {
      await _metaSdk.setUserId(userId);
    } catch (e) {
      print('Meta SDK set user ID error: $e');
    }
  }

  /// Clear user ID
  /// Call this when user logs out
  Future<void> clearUserId() async {
    try {
      await _metaSdk.clearUserId();
    } catch (e) {
      print('Meta SDK clear user ID error: $e');
    }
  }

  /// Set user data for advanced matching
  /// This helps improve ad targeting and conversion tracking
  Future<void> setUserData({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) async {
    try {
      final userData = <String, String>{};
      if (email != null) userData['em'] = email;
      if (firstName != null) userData['fn'] = firstName;
      if (lastName != null) userData['ln'] = lastName;
      if (phone != null) userData['ph'] = phone;
      if (city != null) userData['ct'] = city;
      if (state != null) userData['st'] = state;
      if (zipCode != null) userData['zp'] = zipCode;
      if (country != null) userData['country'] = country;

      if (userData.isNotEmpty) {
        await _metaSdk.setUserData(userData);
      }
    } catch (e) {
      print('Meta SDK set user data error: $e');
    }
  }

  /// Clear user data
  Future<void> clearUserData() async {
    try {
      await _metaSdk.clearUserData();
    } catch (e) {
      print('Meta SDK clear user data error: $e');
    }
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:flutter/material.dart';

class MyRouteObserver extends AutoRouterObserver {
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  // Mapping from route names to back button events.
  // Include both path-style names and AutoRoute-generated names (e.g. NotificationsRoute)
  // so back events are logged when system back is used on Android.
  static final Map<String, String> _routeToBackEvent = {
    '/notifications': AppEvents.notificationsClickBack,
    '/favourites': AppEvents.favouritesClickBack,
    '/maincategory': AppEvents.maincategoryClickBack,
    '/reels': AppEvents.reelsClickBack,
    '/search': AppEvents.searchClickBack,
    '/search-media': AppEvents.searchMediaClickBack,
    '/chat': AppEvents.chatClickBack,
    '/profile': AppEvents.profileClickBack,
    '/qr-code': AppEvents.qrCodeClickBack,
    '/coupon-qrcode': AppEvents.couponQrCodeBack,
    '/coupon-qrcode-details': AppEvents.couponQrCodeDetailsBack,
    '/booking-history': AppEvents.bookingHistoryClickBack,
    '/issue': AppEvents.issueClickBack,
    '/payments': AppEvents.paymentsClickBack,
    '/payment-methods': AppEvents.paymentMethodsClickBack,
    '/brand': AppEvents.brandClickBack,
    '/brand-media': AppEvents.brandMediaClickBack,
    '/services': AppEvents.servicesClickBack,
    '/service-details': AppEvents.serviceDetailsClickBack,
    '/all-reviews': AppEvents.allReviewsClickBack,
    '/service-availability': AppEvents.calendarClickBack,
    '/confirmation-booking': AppEvents.confirmationBookingClickBack,
    '/booking-status': AppEvents.bookingStatusClickBack,
    '/popular-brands': AppEvents.popularClickBrandsBack,
    '/popular-services': AppEvents.popularClickServicesBack,
    '/toprated-brands': AppEvents.topratedClickBrandsBack,
    '/toprated-services': AppEvents.topratedClickServicesBack,
    // AutoRoute-generated route names (route.settings.name from AutoRoute)
    'NotificationsRoute': AppEvents.notificationsClickBack,
    'MyFavoriteRoute': AppEvents.favouritesClickBack,
    'CategoryRoute': AppEvents.maincategoryClickBack,
    'ReelsRoute': AppEvents.reelsClickBack,
    'ReelsTabRoute': AppEvents.reelsClickBack,
    'SearchRoute': AppEvents.searchClickBack,
    'SearchTabRoute': AppEvents.searchClickBack,
    'SearchInputRoute': AppEvents.searchClickBack,
    'SearchPostRoute': AppEvents.searchMediaClickBack,
    'ReelViewerRoute': AppEvents.searchMediaClickBack,
    'ConversationsRoute': AppEvents.chatClickBack,
    'ChatTabRoute': AppEvents.chatClickBack,
    'ProfileRoute': AppEvents.profileClickBack,
    'ProfileTabRoute': AppEvents.profileClickBack,
    'QrScannerRoute': AppEvents.qrCodeClickBack,
    'BookingsHistoryRoute': AppEvents.bookingHistoryClickBack,
    'BookingStatusRoute': AppEvents.bookingStatusClickBack,
    'SeeAllReviewsRoute': AppEvents.allReviewsClickBack,
    'ServiceAvailabilityRoute': AppEvents.calendarClickBack,
    'PopularBrandsRoute': AppEvents.popularClickBrandsBack,
    'PopularServicesRoute': AppEvents.popularClickServicesBack,
    'TopRatedBrandsRoute': AppEvents.topratedClickBrandsBack,
    'TopRatedServicesRoute': AppEvents.topratedClickServicesBack,
    'BrandRecommendationInputRoute': AppEvents.brandRecommendationBack,
    'BrandRecommendationResultsRoute': AppEvents.brandRecommendationBack,
    'BrandRecommendationDetailsRoute': AppEvents.brandRecommendationBack,
    'BrandRecommendationHistoryRoute': AppEvents.brandRecommendationHistoryBack,
  };

  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('--New route pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('--Route Popped : ${route.settings.name}');
    
    // Log back button event if route has a mapping
    final routeName = route.settings.name;
    if (routeName != null && _routeToBackEvent.containsKey(routeName)) {
      final event = _routeToBackEvent[routeName]!;
      _logger.logEvent(event: event);
    } else if (routeName != null) {
      // Try to extract event from route name pattern
      // e.g., "/ServiceAvailabilityRoute" -> "calendar-click-back"
      final normalizedName = routeName.toLowerCase()
          .replaceAll('route', '')
          .replaceAll('/', '');
      
      // Check if route name contains keywords that match known events
      if (normalizedName.contains('serviceavailability') || 
          normalizedName.contains('calendar')) {
        _logger.logEvent(event: AppEvents.calendarClickBack);
      } else if (normalizedName.contains('notification')) {
        _logger.logEvent(event: AppEvents.notificationsClickBack);
      } else if (normalizedName.contains('favourite')) {
        _logger.logEvent(event: AppEvents.favouritesClickBack);
      } else if (normalizedName.contains('maincategory')) {
        _logger.logEvent(event: AppEvents.maincategoryClickBack);
      } else if (normalizedName.contains('reel')) {
        _logger.logEvent(event: AppEvents.reelsClickBack);
      } else if (normalizedName.contains('search')) {
        if (normalizedName.contains('media')) {
          _logger.logEvent(event: AppEvents.searchMediaClickBack);
        } else {
          _logger.logEvent(event: AppEvents.searchClickBack);
        }
      } else if (normalizedName.contains('chat')) {
        _logger.logEvent(event: AppEvents.chatClickBack);
      } else if (normalizedName.contains('profile')) {
        _logger.logEvent(event: AppEvents.profileClickBack);
      } else if (normalizedName.contains('qrcode') || normalizedName.contains('qr-code')) {
        if (normalizedName.contains('detail')) {
          _logger.logEvent(event: AppEvents.couponQrCodeDetailsBack);
        } else if (normalizedName.contains('coupon')) {
          _logger.logEvent(event: AppEvents.couponQrCodeBack);
        } else {
          _logger.logEvent(event: AppEvents.qrCodeClickBack);
        }
      } else if (normalizedName.contains('bookinghistory')) {
        _logger.logEvent(event: AppEvents.bookingHistoryClickBack);
      } else if (normalizedName.contains('issue')) {
        _logger.logEvent(event: AppEvents.issueClickBack);
      } else if (normalizedName.contains('payment')) {
        if (normalizedName.contains('method')) {
          _logger.logEvent(event: AppEvents.paymentMethodsClickBack);
        } else {
          _logger.logEvent(event: AppEvents.paymentsClickBack);
        }
      } else if (normalizedName.contains('brand')) {
        if (normalizedName.contains('media')) {
          _logger.logEvent(event: AppEvents.brandMediaClickBack);
        } else if (!normalizedName.contains('term')) {
          // Don't log brand-click-back when closing BrandTermsSheet (e.g. navigating to ServiceInvoiceRoute)
          _logger.logEvent(event: AppEvents.brandClickBack);
        }
      } else if (normalizedName.contains('service')) {
        if (normalizedName.contains('detail')) {
          _logger.logEvent(event: AppEvents.serviceDetailsClickBack);
        } else {
          _logger.logEvent(event: AppEvents.servicesClickBack);
        }
      } else if (normalizedName.contains('review')) {
        _logger.logEvent(event: AppEvents.allReviewsClickBack);
      } else if (normalizedName.contains('confirmationbooking')) {
        _logger.logEvent(event: AppEvents.confirmationBookingClickBack);
      } else if (normalizedName.contains('bookingstatus')) {
        _logger.logEvent(event: AppEvents.bookingStatusClickBack);
      } else if (normalizedName.contains('popular')) {
        if (normalizedName.contains('brand')) {
          _logger.logEvent(event: AppEvents.popularClickBrandsBack);
        } else if (normalizedName.contains('service')) {
          _logger.logEvent(event: AppEvents.popularClickServicesBack);
        }
      } else if (normalizedName.contains('toprated')) {
        if (normalizedName.contains('brand')) {
          _logger.logEvent(event: AppEvents.topratedClickBrandsBack);
        } else if (normalizedName.contains('service')) {
          _logger.logEvent(event: AppEvents.topratedClickServicesBack);
        }
      }
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint('--Route Removed : ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint(
        '--OldRoute : ${oldRoute!.settings.name} was replaced by ${newRoute!.settings.name}');
  }

  // only override to observer tab routes
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    debugPrint('--Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    debugPrint('--Tab route re-visited: ${route.name}');
  }
}

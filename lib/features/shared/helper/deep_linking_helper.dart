import 'package:app_links/app_links.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';

class DeepLinkingHelper {
  static void init() {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      debugPrint('url:$uri');
      handleDeepLink(uri);
    });
  }

  static void handleDeepLink(Uri uri) {
    try {
      final segments = uri.scheme == 'dazzify'
          ? [uri.host, ...uri.pathSegments]
          : uri.pathSegments;

      if (segments.isEmpty) return;
      if (segments[0] == 'service') {
        String serviceId = segments[1];
        // Navigate to the service page
        getIt<AppRouter>().push(
          ServiceDetailsRoute(
            serviceId: serviceId,
          ),
        );
      } else if (segments[0] == 'brand') {
        String brandUserName = segments[1];
        // Navigate to the brand page
        getIt<AppRouter>().push(
          BrandProfileRoute(
            brandSlug: brandUserName,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error handling deep link: $e');
    }
  }
}

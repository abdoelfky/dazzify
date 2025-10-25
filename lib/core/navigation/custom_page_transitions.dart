import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Custom page transitions for the app
/// Provides smooth, beautiful animations for all navigation
/// 
/// Usage:
/// - The default transition is automatically applied to all routes via AppRouter
/// - To use a different transition for specific routes, specify in AutoRoute:
/// 
/// ```dart
/// AutoRoute(
///   page: MyRoute.page,
///   customRouteBuilder: (context, child, config) {
///     return CustomPageTransitions.fadeThrough().builder(context, child, config);
///   },
/// )
/// ```
/// 
/// Available transitions:
/// - `slideAndFade()`: Slides from right with fade (default)
/// - `fadeThrough()`: Crossfades with subtle scale
/// - `sharedAxis()`: Material Design shared axis
/// - `scaleAndFade()`: Grows from center with fade
/// - `smoothSlide()`: Slide with parallax effect
/// - `slideUp()`: Slides up from bottom with fade
class CustomPageTransitions {
  /// Default slide and fade transition
  /// Slides in from right with a subtle fade effect
  static RouteType slideAndFade() {
    return RouteType.custom(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        // Fade transition
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      durationInMilliseconds: 350,
      reverseDurationInMilliseconds: 300,
    );
  }

  /// Fade through transition
  /// Current screen fades out while new screen fades in
  static RouteType fadeThrough() {
    return RouteType.custom(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        
        var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        var scaleTween = Tween<double>(begin: 0.92, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      },
      durationInMilliseconds: 300,
      reverseDurationInMilliseconds: 250,
    );
  }

  /// Shared axis transition (Material Design)
  /// Slides with a subtle scale effect
  static RouteType sharedAxis() {
    return RouteType.custom(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        
        // Incoming screen animation
        var slideInTween = Tween<Offset>(
          begin: const Offset(0.05, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        var fadeInTween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        // Outgoing screen animation
        var slideOutTween = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.05, 0.0),
        ).chain(CurveTween(curve: curve));

        var fadeOutTween = Tween<double>(begin: 1.0, end: 0.0).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(slideInTween),
          child: FadeTransition(
            opacity: animation.drive(fadeInTween),
            child: SlideTransition(
              position: secondaryAnimation.drive(slideOutTween),
              child: FadeTransition(
                opacity: secondaryAnimation.drive(fadeOutTween),
                child: child,
              ),
            ),
          ),
        );
      },
      durationInMilliseconds: 350,
      reverseDurationInMilliseconds: 300,
    );
  }

  /// Scale and fade transition
  /// Grows from center with fade
  static RouteType scaleAndFade() {
    return RouteType.custom(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        
        var scaleTween = Tween<double>(begin: 0.85, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      durationInMilliseconds: 300,
      reverseDurationInMilliseconds: 250,
    );
  }

  /// Smooth slide transition with parallax effect
  /// More sophisticated slide with secondary animation
  static RouteType smoothSlide() {
    return RouteType.custom(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        // Incoming screen slides in from right
        var incomingTween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        // Outgoing screen slides slightly to the left with parallax effect
        var outgoingTween = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.3, 0.0),
        ).chain(CurveTween(curve: curve));

        // Fade out the outgoing screen slightly
        var fadeOutTween = Tween<double>(begin: 1.0, end: 0.7).chain(
          CurveTween(curve: curve),
        );

        return Stack(
          children: [
            // Outgoing screen with parallax and fade
            SlideTransition(
              position: secondaryAnimation.drive(outgoingTween),
              child: FadeTransition(
                opacity: secondaryAnimation.drive(fadeOutTween),
                child: child,
              ),
            ),
            // Incoming screen
            SlideTransition(
              position: animation.drive(incomingTween),
              child: child,
            ),
          ],
        );
      },
      durationInMilliseconds: 350,
      reverseDurationInMilliseconds: 300,
    );
  }

  /// Elegant fade and slide up transition
  /// Perfect for modal-style presentations
  static RouteType slideUp() {
    return RouteType.custom(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutCubic;
        
        var slideTween = Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      durationInMilliseconds: 300,
      reverseDurationInMilliseconds: 250,
    );
  }
}

import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dazzify/core/util/extensions.dart';

/// Custom page route builder that enables swipe-back navigation on all platforms.
/// On iOS: Uses native Cupertino swipe-back gesture
/// On Android and other platforms: Implements custom swipe-back gesture
class SwipeBackPageRouteBuilder<T> extends PageRouteBuilder<T> {
  SwipeBackPageRouteBuilder({
    required Widget child,
    required RouteSettings settings,
    bool fullscreenDialog = false,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) {
      // On non-iOS platforms, wrap with swipe-back gesture detector
      if (!_isIOS) {
        return SwipeBackWrapper(
          child: child,
        );
      }
      return child;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Use Cupertino-style slide transition on all platforms
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: transitionDuration,
    settings: settings,
    fullscreenDialog: fullscreenDialog,
  );

  static bool get _isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }
}

/// Wrapper widget that enables swipe-back gesture on Android and other platforms
class SwipeBackWrapper extends StatefulWidget {
  final Widget child;

  const SwipeBackWrapper({
    super.key,
    required this.child,
  });

  @override
  State<SwipeBackWrapper> createState() => _SwipeBackWrapperState();
}

class _SwipeBackWrapperState extends State<SwipeBackWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragDistance = 0.0;
  bool _canPop = true;
  BuildContext? _routerContext;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details, BuildContext routerContext) {
    final screenWidth = MediaQuery.of(routerContext).size.width;
    final textDirection = Directionality.of(routerContext);
    final startPosition = details.localPosition.dx;

    // For RTL (Arabic), swipe from right edge. For LTR (English), swipe from left edge
    // Increased swipe area from 50px to 80px for easier gesture activation
    final isValidSwipePosition = textDirection == TextDirection.rtl
        ? startPosition > screenWidth - 80  // Right edge for RTL
        : startPosition < 80;                // Left edge for LTR

    if (!isValidSwipePosition) {
      _canPop = false;
      return;
    }
    // Use AutoRouter to check if we can pop, which handles nested navigation correctly
    _canPop = routerContext.router.canPop();
  }

  void _handleDragUpdate(DragUpdateDetails details, BuildContext routerContext) {
    if (!_canPop) return;

    final textDirection = Directionality.of(routerContext);
    final delta = details.primaryDelta ?? 0;

    setState(() {
      // For RTL, drag left (negative delta) means going back
      // For LTR, drag right (positive delta) means going back
      final dragValue = textDirection == TextDirection.rtl ? -delta : delta;
      _dragDistance += dragValue;

      // Clamp drag distance to prevent negative values
      _dragDistance = _dragDistance.clamp(0.0, double.infinity);

      // Update animation controller based on drag progress
      final screenWidth = MediaQuery.of(routerContext).size.width;
      _controller.value = (_dragDistance / screenWidth).clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd(DragEndDetails details, BuildContext routerContext) {
    if (!_canPop) {
      _resetDrag();
      return;
    }

    final screenWidth = MediaQuery.of(routerContext).size.width;
    final threshold = screenWidth * 0.25; // 25% of screen width (reduced for easier activation)
    final velocity = details.primaryVelocity ?? 0;
    final textDirection = Directionality.of(routerContext);

    // For RTL, negative velocity means swiping left (back gesture)
    // For LTR, positive velocity means swiping right (back gesture)
    final effectiveVelocity = textDirection == TextDirection.rtl ? -velocity : velocity;

    // Pop if dragged beyond threshold or if velocity is high enough
    if (_dragDistance > threshold || effectiveVelocity > 500) {
      _controller.animateTo(1.0).then((_) {
        if (mounted && _routerContext != null) {
          // Use AutoRouter's maybePop for proper nested navigation handling
          _routerContext!.maybePop();
        }
      });
    } else {
      _resetDrag();
    }
  }

  void _resetDrag() {
    _controller.animateTo(0.0).then((_) {
      if (mounted) {
        setState(() {
          _dragDistance = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap child with Builder to get a context that has access to AutoRouter
    return Builder(
      builder: (routerContext) {
        // Store the router context for use in gesture handlers
        _routerContext = routerContext;
        
        return GestureDetector(
          // Translucent behavior allows underlying widgets to receive gestures
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (details) => _handleDragStart(details, routerContext),
          onHorizontalDragUpdate: (details) => _handleDragUpdate(details, routerContext),
          onHorizontalDragEnd: (details) => _handleDragEnd(details, routerContext),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final screenWidth = MediaQuery.of(context).size.width;
              final textDirection = Directionality.of(context);

              // For RTL, slide to the left (negative). For LTR, slide to the right (positive)
              final offset = textDirection == TextDirection.rtl
                  ? -(_controller.value * screenWidth)
                  : _controller.value * screenWidth;

              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Custom route type for auto_route that provides swipe-back on all platforms
RouteType swipeBackRouteType() {
  return RouteType.custom(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    durationInMilliseconds: 300,
    reverseDurationInMilliseconds: 300,
  );
}

/// Extension on RouteType to provide a swipeBack type
extension SwipeBackRouteType on RouteType {
  static RouteType swipeBack() {
    // On iOS, use cupertino which has native swipe-back
    if (!kIsWeb && Platform.isIOS) {
      return const RouteType.cupertino();
    }

    // On other platforms, use custom route with swipe-back gesture
    return swipeBackRouteType();
  }
}

/// Navigator wrapper that adds swipe-back gesture to all routes
class SwipeBackNavigator extends StatefulWidget {
  final Widget child;

  const SwipeBackNavigator({
    super.key,
    required this.child,
  });

  @override
  State<SwipeBackNavigator> createState() => _SwipeBackNavigatorState();
}

class _SwipeBackNavigatorState extends State<SwipeBackNavigator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragDistance = 0.0;
  bool _isDragging = false;
  bool _canPop = true;
  BuildContext? _routerContext;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details, BuildContext routerContext) {
    final screenWidth = MediaQuery.of(routerContext).size.width;
    final textDirection = Directionality.of(routerContext);
    final startPosition = details.globalPosition.dx;

    // For RTL (Arabic), swipe from right edge. For LTR (English), swipe from left edge
    // Increased swipe area from 50px to 80px for easier gesture activation
    final isValidSwipePosition = textDirection == TextDirection.rtl
        ? startPosition > screenWidth - 80  // Right edge for RTL
        : startPosition < 80;                // Left edge for LTR

    if (!isValidSwipePosition) {
      _canPop = false;
      return;
    }

    // Use AutoRouter to check if we can pop, which handles nested navigation correctly
    _canPop = routerContext.router.canPop();

    if (_canPop) {
      setState(() {
        _isDragging = true;
        _dragDistance = 0.0;
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details, BuildContext routerContext) {
    if (!_canPop || !_isDragging) return;

    final textDirection = Directionality.of(routerContext);
    final delta = details.primaryDelta ?? 0;

    setState(() {
      // For RTL, drag left (negative delta) means going back
      // For LTR, drag right (positive delta) means going back
      final dragValue = textDirection == TextDirection.rtl ? -delta : delta;
      _dragDistance += dragValue;

      // Clamp drag distance to prevent negative values
      _dragDistance = _dragDistance.clamp(0.0, double.infinity);

      // Update animation controller based on drag progress
      final screenWidth = MediaQuery.of(routerContext).size.width;
      _controller.value = (_dragDistance / screenWidth).clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd(DragEndDetails details, BuildContext routerContext) {
    if (!_canPop || !_isDragging) {
      setState(() {
        _isDragging = false;
      });
      return;
    }

    final screenWidth = MediaQuery.of(routerContext).size.width;
    final threshold = screenWidth * 0.25; // 25% of screen width (reduced for easier activation)
    final velocity = details.primaryVelocity ?? 0;
    final textDirection = Directionality.of(routerContext);

    // For RTL, negative velocity means swiping left (back gesture)
    // For LTR, positive velocity means swiping right (back gesture)
    final effectiveVelocity = textDirection == TextDirection.rtl ? -velocity : velocity;

    // Pop if dragged beyond threshold or if velocity is high enough
    if (_dragDistance > threshold || effectiveVelocity > 500) {
      // Animate to completion and then pop
      _controller.animateTo(1.0, curve: Curves.easeOut).then((_) {
        if (mounted && _routerContext != null) {
          // Use AutoRouter's maybePop for proper nested navigation handling
          _routerContext!.maybePop();
          _resetDrag();
        }
      });
    } else {
      _resetDrag();
    }
  }

  void _resetDrag() {
    _controller.animateTo(0.0, curve: Curves.easeOut).then((_) {
      if (mounted) {
        setState(() {
          _dragDistance = 0.0;
          _isDragging = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap child with Builder to get a context that has access to AutoRouter
    return Builder(
      builder: (routerContext) {
        // Store the router context for use in gesture handlers
        _routerContext = routerContext;
        
        return GestureDetector(
          // Translucent behavior allows underlying widgets (ScrollViews, etc.) to receive gestures
          // The gesture only activates when starting from the screen edge (50px)
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (details) => _handleDragStart(details, routerContext),
          onHorizontalDragUpdate: (details) => _handleDragUpdate(details, routerContext),
          onHorizontalDragEnd: (details) => _handleDragEnd(details, routerContext),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final screenWidth = MediaQuery.of(context).size.width;
              final textDirection = Directionality.of(context);

              // For RTL, slide to the left (negative). For LTR, slide to the right (positive)
              final offset = textDirection == TextDirection.rtl
                  ? -(_controller.value * screenWidth)
                  : _controller.value * screenWidth;

              return Stack(
                children: [
                  // Previous screen shadow/overlay
                  if (_controller.value > 0)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.3 * (1 - _controller.value)),
                      ),
                    ),
                  // Current screen
                  Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  ),
                ],
              );
            },
            child: widget.child,
          ),
        );
      },
    );
  }
}

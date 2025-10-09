import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  void _handleDragStart(DragStartDetails details) {
    // Only allow swipe-back from the left edge of the screen
    if (details.localPosition.dx > 50) {
      _canPop = false;
      return;
    }
    _canPop = Navigator.of(context).canPop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_canPop) return;

    setState(() {
      _dragDistance += details.primaryDelta ?? 0;
      // Clamp drag distance to prevent negative values
      _dragDistance = _dragDistance.clamp(0.0, double.infinity);
      
      // Update animation controller based on drag progress
      final screenWidth = MediaQuery.of(context).size.width;
      _controller.value = (_dragDistance / screenWidth).clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_canPop) {
      _resetDrag();
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3; // 30% of screen width
    final velocity = details.primaryVelocity ?? 0;

    // Pop if dragged beyond threshold or if velocity is high enough
    if (_dragDistance > threshold || velocity > 500) {
      _controller.animateTo(1.0).then((_) {
        if (mounted) {
          Navigator.of(context).pop();
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
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_controller.value * MediaQuery.of(context).size.width, 0),
            child: child,
          );
        },
        child: widget.child,
      ),
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

  void _handleDragStart(DragStartDetails details) {
    // Only allow swipe-back from the left 50 pixels of the screen
    if (details.globalPosition.dx > 50) {
      _canPop = false;
      return;
    }

    // Check if we can actually pop
    final navigator = Navigator.maybeOf(context);
    _canPop = navigator != null && navigator.canPop();
    
    if (_canPop) {
      setState(() {
        _isDragging = true;
        _dragDistance = 0.0;
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_canPop || !_isDragging) return;

    setState(() {
      _dragDistance += details.primaryDelta ?? 0;
      // Clamp drag distance to prevent negative values
      _dragDistance = _dragDistance.clamp(0.0, double.infinity);
      
      // Update animation controller based on drag progress
      final screenWidth = MediaQuery.of(context).size.width;
      _controller.value = (_dragDistance / screenWidth).clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_canPop || !_isDragging) {
      setState(() {
        _isDragging = false;
      });
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.35; // 35% of screen width
    final velocity = details.primaryVelocity ?? 0;

    // Pop if dragged beyond threshold or if velocity is high enough
    if (_dragDistance > threshold || velocity > 700) {
      // Animate to completion and then pop
      _controller.animateTo(1.0, curve: Curves.easeOut).then((_) {
        if (mounted) {
          final navigator = Navigator.maybeOf(context);
          if (navigator != null && navigator.canPop()) {
            navigator.pop();
          }
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
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final screenWidth = MediaQuery.of(context).size.width;
          final offset = _controller.value * screenWidth;
          
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
  }
}

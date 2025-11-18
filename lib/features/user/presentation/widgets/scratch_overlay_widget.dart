import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scratcher/scratcher.dart';

class ScratchOverlayWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onThresholdReached;
  final Color overlayColor;
  final double? width;
  final double? height;
  final bool preventScroll;

  const ScratchOverlayWidget({
    super.key,
    required this.child,
    required this.onThresholdReached,
    this.overlayColor = const Color(0xFF7B3FF2),
    this.width,
    this.height,
    this.preventScroll = true,
  });

  @override
  State<ScratchOverlayWidget> createState() => _ScratchOverlayWidgetState();
}

class _ScratchOverlayWidgetState extends State<ScratchOverlayWidget> {
  bool _isScratching = false;
  final ScrollController? _scrollController = null;

  @override
  Widget build(BuildContext context) {
    final scratchWidget = Scratcher(
      brushSize: 35,
      threshold: 55,
      color: Colors.grey.shade800,
      onChange: (value) {
        // Optional: Track scratching progress
      },
      onThreshold: widget.onThresholdReached,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade800.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          children: [
            widget.child,
            // Vintage scratch overlay with pattern
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade700.withOpacity(0.3),
                    Colors.grey.shade800.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Scratch hint overlay
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app,
                    color: Colors.white70,
                    size: 18.r,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    context.tr.scratchToRedeem,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!widget.preventScroll) {
      return scratchWidget;
    }

    // Wrap with gesture detector to prevent scrolling during scratch
    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isScratching = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _isScratching = false;
        });
      },
      onPointerCancel: (_) {
        setState(() {
          _isScratching = false;
        });
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Prevent scroll when scratching
          return _isScratching;
        },
        child: scratchWidget,
      ),
    );
  }
}

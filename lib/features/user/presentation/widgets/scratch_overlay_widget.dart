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
      brushSize: 40,
      threshold: 60,
      color: widget.overlayColor.withOpacity(0.9),
      onChange: (value) {
        // Optional: Track scratching progress
      },
      onThreshold: widget.onThresholdReached,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.overlayColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          children: [
            widget.child,
            // Scratch overlay with darker color matching the card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: widget.overlayColor.withOpacity(0.85),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            // Scratch pattern overlay for texture
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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

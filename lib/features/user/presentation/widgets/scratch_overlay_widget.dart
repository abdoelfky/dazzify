import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scratcher/scratcher.dart';

class ScratchOverlayWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onThresholdReached;
  final VoidCallback? onScratchStart;
  final Color overlayColor;
  final double? width;
  final double? height;
  final bool preventScroll;

  const ScratchOverlayWidget({
    super.key,
    required this.child,
    required this.onThresholdReached,
    this.onScratchStart,
    this.overlayColor = const Color(0xFF7B3FF2),
    this.width,
    this.height,
    this.preventScroll = true,
  });

  @override
  State<ScratchOverlayWidget> createState() => _ScratchOverlayWidgetState();
}

class _ScratchOverlayWidgetState extends State<ScratchOverlayWidget> {
  bool _hasStartedScratching = false;

  @override
  Widget build(BuildContext context) {
    final scratchWidget = Scratcher(
      brushSize: 50,
      threshold: 45,
      color: widget.overlayColor.withOpacity(0.95),
      onChange: (value) {
        // Call onScratchStart only once when scratching begins
        if (!_hasStartedScratching && value > 0) {
          _hasStartedScratching = true;
          widget.onScratchStart?.call();
        }
      },
      onThreshold: widget.onThresholdReached,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: widget.child,
      ),
    );

    // Return the scratch widget directly without scroll prevention
    // The Scratcher widget handles gestures internally
    return scratchWidget;
  }
}

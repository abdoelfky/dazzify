
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_scratcher.dart';

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
    final scratchWidget = CustomScratcher(
      brushSize: 40,
      threshold: 25,
      enabled: true,
      accuracy: ScratchAccuracy.low,
      // Use image for visual effect
      image: Image(
        image: AssetImage('assets/images/scratcher.png'),
        fit: BoxFit.cover,
      ),
      // color: widget.overlayColor.withOpacity(0.3),
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

    // CustomScratcher already handles gesture arena correctly
    // No need for additional wrappers
    return scratchWidget;
  }
}

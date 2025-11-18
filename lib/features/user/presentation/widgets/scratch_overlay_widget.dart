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

  const ScratchOverlayWidget({
    super.key,
    required this.child,
    required this.onThresholdReached,
    this.overlayColor = const Color(0xFF7B3FF2),
    this.width,
    this.height,
  });

  @override
  State<ScratchOverlayWidget> createState() => _ScratchOverlayWidgetState();
}

class _ScratchOverlayWidgetState extends State<ScratchOverlayWidget> {
  bool _isScratching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        setState(() {
          _isScratching = true;
        });
      },
      onPanEnd: (_) {
        setState(() {
          _isScratching = false;
        });
      },
      onPanCancel: () {
        setState(() {
          _isScratching = false;
        });
      },
      child: AbsorbPointer(
        absorbing: _isScratching,
        child: Scratcher(
          brushSize: 40,
          threshold: 50,
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
                // Scratch hint overlay
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        color: Colors.white,
                        size: 24.r,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        context.tr.scratchToRedeem,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

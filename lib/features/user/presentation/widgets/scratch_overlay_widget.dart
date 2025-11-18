import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scratcher/scratcher.dart';

class ScratchOverlayWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scratcher(
      brushSize: 40,
      threshold: 50,
      color: overlayColor.withOpacity(0.9),
      onChange: (value) {
        // Optional: Track scratching progress
      },
      onThreshold: onThresholdReached,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: overlayColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            child,
            // Scratch hint overlay
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 32.r,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      context.tr.scratchToRedeem,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

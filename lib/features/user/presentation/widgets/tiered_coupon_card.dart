import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/user/data/models/tiered_coupon/tiered_coupon_model.dart';
import 'package:dazzify/features/user/presentation/widgets/scratch_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TieredCouponCard extends StatelessWidget {
  final TieredCouponModel coupon;
  final VoidCallback? onScratchComplete;
  final int? couponIndex;

  const TieredCouponCard({
    super.key,
    required this.coupon,
    this.onScratchComplete,
    this.couponIndex,
  });

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideColor = _parseColor(coupon.color?.sideBackground ?? '#B47FF0');
    final bodyColor = _parseColor(coupon.color?.bodyBackground ?? '#3FD6A6');
    final bool shouldShowScratch = !coupon.opened && !coupon.locked;

    final couponCard = CustomPaint(
      painter: TicketPainter(
        sideColor: sideColor.withOpacity(coupon.locked ? 0.5 : 1.0),
        bodyColor: bodyColor.withOpacity(coupon.locked ? 0.5 : 1.0),
        sideWidth: 50.w,
      ),
      child: Container(
        height: 140.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Stack(
          children: [
            Row(
              children: [
                // Side bar with "Discount" text
                SizedBox(
                  width: 50.w,
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        context.tr.discount,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                // Main content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header text
                        if (!coupon.locked && coupon.opened)
                          Text(
                            context.tr.copyCouponCoded,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (!coupon.locked && coupon.opened) SizedBox(height: 5.h),
                        
                        // Discount percentage
                        Text(
                          '${coupon.discountPercentage}%',
                          style: context.textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        
                        // Coupon code or locked message
                        if (coupon.locked)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.tr.locked,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 20.r,
                              ),
                            ],
                          )
                        else if (coupon.code != null && coupon.opened)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 60.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              coupon.code!,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Lock overlay with blur for locked coupons
            if (coupon.locked)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    // Wrap with scratch overlay if needed
    if (shouldShowScratch) {
      return ScratchOverlayWidget(
        onThresholdReached: () {
          if (onScratchComplete != null) {
            onScratchComplete!();
          }
        },
        overlayColor: bodyColor,
        child: couponCard,
      );
    }

    return couponCard;
  }
}

class TicketPainter extends CustomPainter {
  final Color sideColor;
  final Color bodyColor;
  final double sideWidth;

  TicketPainter({
    required this.sideColor,
    required this.bodyColor,
    required this.sideWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final double cutoutRadius = 12;
    final double cutoutSpacing = 30;

    // Draw left side (purple/colored side)
    paint.color = sideColor;
    final leftPath = Path();
    leftPath.moveTo(16, 0);
    leftPath.lineTo(sideWidth, 0);
    leftPath.lineTo(sideWidth, size.height);
    leftPath.lineTo(16, size.height);
    leftPath.arcToPoint(
      Offset(16, size.height - cutoutRadius * 2),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    // Add cutouts on the left side
    double currentY = size.height - cutoutRadius * 2;
    while (currentY > cutoutRadius * 2) {
      currentY -= cutoutSpacing;
      if (currentY > cutoutRadius * 2) {
        leftPath.lineTo(16, currentY + cutoutRadius);
        leftPath.arcToPoint(
          Offset(16, currentY - cutoutRadius),
          radius: Radius.circular(cutoutRadius),
          clockwise: false,
        );
      }
    }

    leftPath.lineTo(16, cutoutRadius * 2);
    leftPath.arcToPoint(
      Offset(16, 0),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    leftPath.close();
    canvas.drawPath(leftPath, paint);

    // Draw right side (green/body color)
    paint.color = bodyColor;
    final rightPath = Path();
    rightPath.moveTo(sideWidth, 0);
    rightPath.lineTo(size.width - 16, 0);
    rightPath.arcToPoint(
      Offset(size.width - 16, cutoutRadius * 2),
      radius: Radius.circular(cutoutRadius),
      clockwise: true,
    );

    // Add cutouts on the right side
    currentY = cutoutRadius * 2;
    while (currentY < size.height - cutoutRadius * 2) {
      currentY += cutoutSpacing;
      if (currentY < size.height - cutoutRadius * 2) {
        rightPath.lineTo(size.width - 16, currentY - cutoutRadius);
        rightPath.arcToPoint(
          Offset(size.width - 16, currentY + cutoutRadius),
          radius: Radius.circular(cutoutRadius),
          clockwise: true,
        );
      }
    }

    rightPath.lineTo(size.width - 16, size.height - cutoutRadius * 2);
    rightPath.arcToPoint(
      Offset(size.width - 16, size.height),
      radius: Radius.circular(cutoutRadius),
      clockwise: true,
    );
    rightPath.lineTo(sideWidth, size.height);
    rightPath.close();
    canvas.drawPath(rightPath, paint);

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(leftPath, shadowPaint);
    canvas.drawPath(rightPath, shadowPaint);
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;
}

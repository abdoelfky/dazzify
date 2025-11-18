import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/user/data/models/tiered_coupon/tiered_coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TieredCouponDetailsCard extends StatelessWidget {
  final TieredCouponModel coupon;

  const TieredCouponDetailsCard({
    super.key,
    required this.coupon,
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Header section with logo and text
          Column(
            children: [
              // Logo
              Text(
                'da dazzify',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7B3FF2),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.tr.redeemYourCoupon,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF7B3FF2),
                ),
              ),
              Text(
                context.tr.forDiscount,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF7B3FF2),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),

          // Coupon card with ticket style
          CustomPaint(
            painter: TicketPainter(
              sideColor: sideColor,
              bodyColor: bodyColor,
              sideWidth: 50.w,
            ),
            child: Container(
              height: 160.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
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
                          Text(
                            context.tr.copyCouponCoded,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          
                          // Discount percentage
                          Text(
                            '${coupon.discountPercentage}%',
                            style: context.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 48.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          
                          // Coupon code
                          if (coupon.code != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 32.w,
                                vertical: 10.h,
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
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Coupon details section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coupon details header
                Text(
                  context.tr.couponDetails,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7B3FF2),
                  ),
                ),
                SizedBox(height: 12.h),

                // Instructions list
                ...coupon.instructions.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF7B3FF2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF7B3FF2),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
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

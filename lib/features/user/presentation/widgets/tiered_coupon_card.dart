import 'dart:ui';

import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/user/data/models/tiered_coupon/tiered_coupon_model.dart';
import 'package:dazzify/features/user/presentation/widgets/scratch_overlay_widget.dart'
    show ScratchOverlayWidget;
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
    final bool shouldShowBlur = coupon.locked && !coupon.opened;
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return ClipPath(
      clipper: TicketClipper(sideWidth: 60.w),
      child: CustomPaint(
          painter: TicketPainter(
            sideColor: sideColor.withOpacity(shouldShowBlur ? 0.5 : 1.0),
            bodyColor: bodyColor.withOpacity(shouldShowBlur ? 0.5 : 1.0),
            sideWidth: 60.w,
            isRTL: isRTL,
          ),
          child: Container(
            height: 140.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Stack(
              children: [
                Row(
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    // Side bar with "Discount" text
                    SizedBox(
                      width: 55.w,
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: isRTL ? 1 : 3,
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
                            if (!shouldShowBlur && coupon.opened)
                              Text(
                                context.tr.copyCouponCoded,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              )
                            else if (!shouldShowBlur && !coupon.opened)
                              Text(
                                context.tr.openToScratch,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            if (!shouldShowBlur) SizedBox(height: 5.h),

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
                            // if (shouldShowScratch)
                            //   // Scratch only on code area
                            //   BlocBuilder<TieredCouponCubit, TieredCouponState>(
                            //     builder: (context, state) {
                            //       // Get the latest coupon data from state
                            //       final latestCoupon = couponIndex != null && couponIndex! < state.coupons.length
                            //           ? state.coupons[couponIndex!]
                            //           : coupon;
                            //
                            //       return ScratchOverlayWidget(
                            //         onScratchStart: () {
                            //           // Fetch real code immediately when scratch starts
                            //           if (couponIndex != null) {
                            //             context.read<TieredCouponCubit>().fetchCouponCodeOnScratchStart(couponIndex!);
                            //           }
                            //         },
                            //         onThresholdReached: () {
                            //           // Mark as opened when threshold reached
                            //           if (couponIndex != null) {
                            //             context.read<TieredCouponCubit>().markCouponAsOpenedOnThreshold(couponIndex!);
                            //           }
                            //           if (onScratchComplete != null) {
                            //             onScratchComplete!();
                            //           }
                            //         },
                            //         overlayColor: Colors.white,
                            //         width: 180.w,
                            //         height: 38.h,
                            //         child: Container(
                            //           width: 180.w,
                            //           height: 38.h,
                            //           padding: EdgeInsets.symmetric(
                            //             horizontal: 24.w,
                            //             vertical: 6.h,
                            //           ),
                            //           decoration: BoxDecoration(
                            //             color: Colors.white,
                            //             borderRadius: BorderRadius.circular(8.r),
                            //           ),
                            //           child: Center(
                            //             child: Text(
                            //               latestCoupon.code ?? 'XXXXX',
                            //               style: context.textTheme.bodyLarge?.copyWith(
                            //                 color: Colors.black,
                            //                 fontWeight: FontWeight.bold,
                            //                 fontSize: 14.sp,
                            //               ),
                            //               textAlign: TextAlign.center,
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   )
                            // Coupon code or locked message
                            if (coupon.code == null)
                              Stack(
                                children: [
                                  ScratchOverlayWidget(
                                    key: ValueKey('scratch_${couponIndex}_'),
                                    onScratchStart: () {
                                      // getIt<AppEventsLogger>().logEvent(
                                      //     event: AppEvents.couponQrCodeScratch);
                                      // // Fetch real code immediately when scratch starts
                                      // context
                                      //     .read<TieredCouponCubit>()
                                      //     .fetchCouponCodeOnScratchStart(couponIndex);
                                    },
                                    onThresholdReached: () {
                                      // Mark as opened when threshold reached
                                      // context
                                      //     .read<TieredCouponCubit>()
                                      //     .markCouponAsOpenedOnThreshold(couponIndex);
                                    },
                                    overlayColor: Colors.white,
                                    width: 200.w,
                                    height: 38.h,
                                    child: Container(
                                      width: 200.w,
                                      height: 38.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 32.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'XXXXX',
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            if (coupon.code != null)
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 200.w,
                                  minWidth: 120.w,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Text(
                                    coupon.code!,
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                    textAlign: TextAlign.center,
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
                if (shouldShowBlur)
                  Positioned.fill(
                    child: ClipPath(
                      clipper: TicketClipper(sideWidth: 60.w),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 4.0,
                          sigmaY: 4.0,
                        ),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                if (shouldShowBlur)
                  Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 5,
                    widthFactor: .9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                    ),
                  )
              ],
            ),
          )),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  final double sideWidth;

  TicketClipper({required this.sideWidth});

  @override
  Path getClip(Size size) {
    final double cutoutRadius = 16;
    final double centerY = size.height / 2;
    final double cornerRadius = 16;

    final path = Path();

    // Start from top-left corner (accounting for rounded corner)
    path.moveTo(cornerRadius, 0);

    // Top edge to top-right corner
    path.lineTo(size.width - cornerRadius, 0);

    // Top-right rounded corner
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Right edge down to cutout
    path.lineTo(size.width, centerY - cutoutRadius);

    // Right side cutout (semicircle going inward)
    path.arcToPoint(
      Offset(size.width, centerY + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    // Right edge down to bottom-right corner
    path.lineTo(size.width, size.height - cornerRadius);

    // Bottom-right rounded corner
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Bottom edge to bottom-left corner
    path.lineTo(cornerRadius, size.height);

    // Bottom-left rounded corner
    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Left edge up to cutout
    path.lineTo(0, centerY + cutoutRadius);

    // Left side cutout (semicircle going inward)
    path.arcToPoint(
      Offset(0, centerY - cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    // Left edge up to top-left corner
    path.lineTo(0, cornerRadius);

    // Top-left rounded corner
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TicketClipper oldClipper) => false;
}

class TicketPainter extends CustomPainter {
  final Color sideColor;
  final Color bodyColor;
  final double sideWidth;
  final bool isRTL;

  TicketPainter({
    required this.sideColor,
    required this.bodyColor,
    required this.sideWidth,
    required this.isRTL,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final double cutoutRadius = 16;
    final double centerY = size.height / 2;

    // ----------- Rounded Corners Clip -----------
    final RRect rounded = RRect.fromLTRBR(
      16,
      0,
      size.width - 16,
      size.height,
      Radius.circular(16),
    );
    canvas.clipRRect(rounded);
    if (isRTL) {
      // RTL Layout - Sidebar on the RIGHT
      // ----------- RIGHT SIDE (Sidebar) -----------
      paint.color = sideColor;
      final rightSidePath = Path()
        ..moveTo(size.width - sideWidth, 0)
        ..lineTo(size.width - 16, 0)
        ..lineTo(size.width - 16, centerY - cutoutRadius)
        ..arcToPoint(
          Offset(size.width - 16, centerY + cutoutRadius),
          radius: Radius.circular(cutoutRadius),
          clockwise: false,
        )
        ..lineTo(size.width - 16, size.height)
        ..lineTo(size.width - sideWidth, size.height)
        ..close();

      canvas.drawPath(rightSidePath, paint);

      // ----------- LEFT SIDE (Body) -----------
      paint.color = bodyColor;
      final leftBodyPath = Path()
        ..moveTo(16, 0)
        ..lineTo(size.width - sideWidth, 0)
        ..lineTo(size.width - sideWidth, size.height)
        ..lineTo(16, size.height)
        ..lineTo(16, centerY + cutoutRadius)
        ..arcToPoint(
          Offset(16, centerY - cutoutRadius),
          radius: Radius.circular(cutoutRadius),
          clockwise: false,
        )
        ..lineTo(16, 0)
        ..close();

      canvas.drawPath(leftBodyPath, paint);

      // ----------- Shadow -----------
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawPath(rightSidePath, shadowPaint);
      canvas.drawPath(leftBodyPath, shadowPaint);
    } else {
      // LTR Layout - Sidebar on the LEFT
      // ----------- LEFT SIDE (Sidebar) -----------
      paint.color = sideColor;
      final leftPath = Path()
        ..moveTo(16, 0)
        ..lineTo(sideWidth, 0)
        ..lineTo(sideWidth, size.height)
        ..lineTo(16, size.height)
        ..lineTo(16, centerY + cutoutRadius)
        ..arcToPoint(
          Offset(16, centerY - cutoutRadius),
          radius: Radius.circular(cutoutRadius),
          clockwise: false,
        )
        ..lineTo(16, 0)
        ..close();

      canvas.drawPath(leftPath, paint);

      // ----------- RIGHT SIDE (Body) -----------
      paint.color = bodyColor;
      final rightPath = Path()
        ..moveTo(sideWidth, 0)
        ..lineTo(size.width - 16, 0)
        ..lineTo(size.width - 16, centerY - cutoutRadius)
        ..arcToPoint(
          Offset(size.width - 16, centerY + cutoutRadius),
          radius: Radius.circular(cutoutRadius),
          clockwise: false,
        )
        ..lineTo(size.width - 16, size.height)
        ..lineTo(sideWidth, size.height)
        ..close();

      canvas.drawPath(rightPath, paint);

      // ----------- Shadow -----------
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawPath(leftPath, shadowPaint);
      canvas.drawPath(rightPath, shadowPaint);
    }
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;
}

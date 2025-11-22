import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/user/data/models/tiered_coupon/tiered_coupon_model.dart';
import 'package:dazzify/features/user/logic/tiered_coupon/tiered_coupon_cubit.dart';
import 'package:dazzify/features/user/logic/tiered_coupon/tiered_coupon_state.dart';
import 'package:dazzify/features/user/presentation/widgets/scratch_overlay_widget.dart';
import 'package:dazzify/settings/theme/colors_scheme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class TieredCouponDetailsScreen extends StatelessWidget {
  final TieredCouponModel coupon;
  final int couponIndex;

  const TieredCouponDetailsScreen({
    super.key,
    required this.coupon,
    required this.couponIndex,
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

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/couponsBackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: DazzifyAppBar(
                  isLeading: true,
                  title: context.tr.coupons,
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 600.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Header section with logo and text
                              Container(
                                height: 37,
                                width: 160,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/couponLogo.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                context.tr.redeemYourCoupon,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ColorsSchemeManager.light.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                context.tr.forDiscount,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ColorsSchemeManager.light.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 20.h),

                              // Coupon card with ticket style
                              _buildCouponCard(context, sideColor, bodyColor),

                              SizedBox(height: 20.h),

                              // Coupon details section
                              if (coupon.opened ||
                                  coupon.instructions.isNotEmpty)
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Coupon details header
                                      Text(
                                        context.tr.couponDetails,
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              ColorsSchemeManager.light.primary,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),

                                      // Instructions list
                                      ...coupon.instructions
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '• ',
                                                style: context
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: ColorsSchemeManager
                                                      .light.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  entry.value,
                                                  style: context
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    color: ColorsSchemeManager
                                                        .light.primary,
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
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponCard(
    BuildContext context,
    Color sideColor,
    Color bodyColor,
  ) {
    final bool shouldShowScratch = !coupon.opened && !coupon.locked;

    final couponCard = CustomPaint(
      painter: TicketPainter(
        sideColor: sideColor,
        bodyColor: bodyColor,
        sideWidth: 60.w,
      ),
      child: Container(
        height: 160.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          children: [
            // Side bar with "Discount" text
            SizedBox(
              width: 55.w,
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
                  horizontal: 12.w,
                  vertical: 16.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header text
                    if (coupon.opened)
                      Text(
                        context.tr.copyCouponCoded,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (!coupon.opened)
                      Text(
                        context.tr.scratchToRedeem,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    if (coupon.opened) SizedBox(height: 6.h),

                    // Discount percentage
                    Text(
                      '${coupon.discountPercentage}%',
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Coupon code with scratch overlay
                    // if (coupon.code != null)
                    shouldShowScratch
                        ? BlocBuilder<TieredCouponCubit, TieredCouponState>(
                            builder: (context, state) {
                              // Get the latest coupon data from state
                              final latestCoupon =
                                  couponIndex < state.coupons.length
                                      ? state.coupons[couponIndex]
                                      : coupon;

                              return ScratchOverlayWidget(
                                onScratchStart: () {
                                  // Fetch real code immediately when scratch starts
                                  context
                                      .read<TieredCouponCubit>()
                                      .fetchCouponCodeOnScratchStart(
                                          couponIndex);
                                },
                                onThresholdReached: () {
                                  // Mark as opened when threshold reached
                                  context
                                      .read<TieredCouponCubit>()
                                      .markCouponAsOpenedOnThreshold(
                                          couponIndex);
                                },
                                overlayColor: Colors.white,
                                width: 200.w,
                                height: 46.h,
                                child: Container(
                                  width: 220.w,
                                  height: 46.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      latestCoupon.code ?? 'XXXXX',
                                      style:
                                          context.textTheme.bodyLarge?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: coupon.code!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.tr.couponCopied),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 200.w,
                                minWidth: 160.w,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  coupon.code!,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
    );

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
    final double cutoutRadius = 16;

    final double centerY = size.height / 2;

    // Draw left side
    paint.color = sideColor;
    final leftPath = Path();

    leftPath.moveTo(16, 0);
    leftPath.lineTo(sideWidth, 0);
    leftPath.lineTo(sideWidth, size.height);
    leftPath.lineTo(16, size.height);

    // One circle cutout at center left
    leftPath.lineTo(16, centerY + cutoutRadius);
    leftPath.arcToPoint(
      Offset(16, centerY - cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    leftPath.lineTo(16, 0);

    leftPath.close();
    canvas.drawPath(leftPath, paint);

// Draw right side (mirror of left)
    paint.color = bodyColor;
    final rightPath = Path();

    rightPath.moveTo(sideWidth, 0);
    rightPath.lineTo(size.width - 16, 0);
    rightPath.lineTo(size.width - 16, centerY - cutoutRadius);

// نفس اتجاه اليسار (clockwise: false)
    rightPath.arcToPoint(
      Offset(size.width - 16, centerY + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    rightPath.lineTo(size.width - 16, size.height);
    rightPath.lineTo(sideWidth, size.height);

    rightPath.close();
    canvas.drawPath(rightPath, paint);


    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(leftPath, shadowPaint);
    canvas.drawPath(rightPath, shadowPaint);
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;
}

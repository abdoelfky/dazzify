import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
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

  TieredCouponDetailsScreen({
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
                  onBackTap: () {
                    getIt<AppEventsLogger>()
                        .logEvent(event: AppEvents.couponQrCodeDetailsBack);
                    context.maybePop();
                  },
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
                                height: 39,
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
    return BlocBuilder<TieredCouponCubit, TieredCouponState>(
      buildWhen: (previous, current) {
        // Rebuild when the specific coupon at couponIndex changes
        if (couponIndex >= previous.coupons.length ||
            couponIndex >= current.coupons.length) {
          return true;
        }
        final prevCoupon = previous.coupons[couponIndex];
        final currCoupon = current.coupons[couponIndex];
        return prevCoupon.opened != currCoupon.opened ||
            prevCoupon.code != currCoupon.code;
      },
      builder: (context, state) {
        // Get the latest coupon from state instead of using the passed parameter
        final latestCoupon = couponIndex < state.coupons.length
            ? state.coupons[couponIndex]
            : coupon;

        final bool shouldShowScratch =
            !latestCoupon.opened && !latestCoupon.locked;

        final couponCard = _buildCouponCardContent(
          context,
          sideColor,
          bodyColor,
          latestCoupon,
          shouldShowScratch,
        );

        return couponCard;
      },
    );
  }

  Widget _buildCouponCardContent(
    BuildContext context,
    Color sideColor,
    Color bodyColor,
    TieredCouponModel currentCoupon,
    bool shouldShowScratch,
  ) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    final couponCard = CustomPaint(
      painter: TicketPainter(
        sideColor: sideColor,
        bodyColor: bodyColor,
        sideWidth: 60.w,
        isRTL: isRTL,
      ),
      child: Container(
        height: 160.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
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
                  horizontal: 12.w,
                  vertical: 16.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header text
                    if (currentCoupon.opened)
                      Text(
                        context.tr.copyCouponCoded,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (!currentCoupon.opened)
                      Text(
                        context.tr.scratchToRedeem,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    if (currentCoupon.opened) SizedBox(height: 6.h),

                    // Discount percentage
                    Text(
                      '${currentCoupon.discountPercentage}%',
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Coupon code with scratch overlay
                    // if (currentCoupon.code != null)
                    shouldShowScratch
                        ? ScratchOverlayWidget(
                            key: ValueKey(
                                'scratch_${couponIndex}_${currentCoupon.opened}'),
                            onScratchStart: () {
                              getIt<AppEventsLogger>().logEvent(
                                  event: AppEvents.couponQrCodeScratch);
                              // Fetch real code immediately when scratch starts
                              context
                                  .read<TieredCouponCubit>()
                                  .fetchCouponCodeOnScratchStart(couponIndex);
                            },
                            onThresholdReached: () {
                              // Mark as opened when threshold reached
                              context
                                  .read<TieredCouponCubit>()
                                  .markCouponAsOpenedOnThreshold(couponIndex);
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
                                  currentCoupon.code ?? 'XXXXX',
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            key: ValueKey(
                                'code_${couponIndex}_${currentCoupon.code}'),
                            onTap: () {
                              if (currentCoupon.code != null &&
                                  currentCoupon.code!.isNotEmpty) {
                                getIt<AppEventsLogger>().logEvent(
                                    event: AppEvents.couponQrCodeCopy);
                                Clipboard.setData(
                                    ClipboardData(text: currentCoupon.code!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.tr.couponCopied),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
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
                                  currentCoupon.code ?? '',
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
        ..color = Colors.black.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

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
        ..color = Colors.black.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawPath(leftPath, shadowPaint);
      canvas.drawPath(rightPath, shadowPaint);
    }
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;
}

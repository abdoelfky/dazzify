import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/widgets/animated_read_more_text.dart';
import 'package:dazzify/features/shared/widgets/dazzify_rounded_picture.dart';
import 'package:lottie/lottie.dart';

class ReelInfoComponent extends StatefulWidget {
  final MediaModel reel;
  final ValueNotifier<bool> isWaveAnimating;

  const ReelInfoComponent({
    super.key,
    required this.reel,
    required this.isWaveAnimating,
  });

  @override
  State<ReelInfoComponent> createState() => _ReelInfoComponentState();
}

class _ReelInfoComponentState extends State<ReelInfoComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.navigateTo(
                  BrandProfileRoute(
                    brand: widget.reel.brand,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DazzifyRoundedPicture(
                  imageUrl: widget.reel.brand.logo,
                ),
              ),
            ),
            SizedBox(width: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.reel.brand.verified
                    ? GestureDetector(
                        onTap: () {
                          context.pushRoute(
                            BrandProfileRoute(
                              brand: widget.reel.brand,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200.w),
                              child: IntrinsicWidth(
                                child:  DText(
                                  maxLines: 1,
                                  widget.reel.brand.name,
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              SolarIconsBold.verifiedCheck,
                              size: 14.r,
                              color: context.colorScheme.primary,
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          context.pushRoute(
                            BrandProfileRoute(brand: widget.reel.brand),
                          );
                        },
                        child: DText(
                          widget.reel.brand.name,
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                DText(
                  buildBookingCountDText(),
                  style: context.textTheme.bodySmall!.copyWith(
                    color: ColorsManager.customGrey,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: 270.w,
          child: AnimatedReadMoreText(
            text: widget.reel.caption,
            textStyle:
                context.textTheme.labelMedium!.copyWith(color: Colors.white),
            linkStyle: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.primary,
            ),
            trimLines: 2,
            moreText: context.tr.more,
            lessText: context.tr.less,
            animationDuration: const Duration(milliseconds: 500),
            animationCurve: Curves.easeInOut,
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            ValueListenableBuilder(
              valueListenable: widget.isWaveAnimating,
              builder: (context, value, child) => Lottie.asset(
                AssetsManager.soundWaves,
                height: 30.r,
                width: 30.r,
                fit: BoxFit.cover,
                animate: !value,
              ),
            ),
            SizedBox(width: 15.w),
            DText(
              context.tr.originalSound,
              style: context.textTheme.bodySmall!.copyWith(
                color: Colors.white,
              ),
            )
          ],
        ),
      ],
    );
  }

  String buildBookingCountDText() {
    if (widget.reel.bookingsCount == 0) {
      return context.tr.noBookings;
    } else if (widget.reel.bookingsCount == 1) {
      return "${widget.reel.bookingsCount} ${context.tr.booking}";
    } else if (widget.reel.bookingsCount == null) {
      return "";
    } else {
      return "${widget.reel.bookingsCount} ${context.tr.bookings}";
    }
  }
}

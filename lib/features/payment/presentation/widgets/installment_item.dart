import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstallmentTile extends StatelessWidget {
  const InstallmentTile({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
    this.isSvg = false,
    this.imageFit,
    this.isInstallment,
  });

  final String image;
  final String title;
  final bool isSvg;
  final bool? isInstallment;
  final BoxFit? imageFit;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 60.h,
            margin: const EdgeInsets.symmetric(horizontal: 16).r,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7).r,
            decoration: BoxDecoration(
              color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.all(
                const Radius.circular(8).r,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4).r,
                  child: isSvg == true
                      ? SizedBox(
                          width: 80.w,
                          child: SvgPicture.asset(
                            image,
                            colorFilter: const ColorFilter.mode(
                              Color(0xff35DE75),
                              BlendMode.srcIn,
                            ),
                            fit: imageFit ?? BoxFit.cover,
                            height: 45.h,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: image,
                          fit: imageFit ?? BoxFit.cover,
                          height: 35.h,
                          width: 80.w,
                        ),
                ),
                SizedBox(width: 40.w),
                DText(title, style: context.textTheme.bodySmall),
                const Spacer(),
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: Icon(
                    context.currentTextDirection == TextDirection.ltr
                        ? SolarIconsOutline.altArrowRight
                        : SolarIconsOutline.altArrowLeft,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 4.h),
        if (isInstallment == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              period(context, context.tr.months6),
              SizedBox(width: 8.r),
              period(context, context.tr.months12),
              SizedBox(width: 8.r),
              period(context, context.tr.months24),
              SizedBox(width: 8.r),
              period(context, context.tr.months36),
              SizedBox(width: 8.r),
            ],
          )
      ],
    );
  }

  Widget period(BuildContext context, String period) {
    return DText(
      period,
      style: context.textTheme.bodySmall!
          .copyWith(color: context.colorScheme.outlineVariant),
    );
  }
}

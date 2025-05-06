import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:flutter_svg/svg.dart';

class TopRatedBrandCard extends StatelessWidget {
  final BrandModel brand;
  final void Function()? onTap;
  final double? ratingTop;
  final double? ratingEnd;
  final double? infoBottom;
  final double? infoStart;
  final TextStyle? nameStyle;

  const TopRatedBrandCard({
    super.key,
    required this.brand,
    this.onTap,
    this.ratingTop,
    this.ratingEnd,
    this.infoStart,
    this.infoBottom,
    this.nameStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8).r,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8).r,
          child: Stack(
            children: [
              Stack(
                children: [
                  DazzifyCachedNetworkImage(
                    height: 160.h,
                    width: 150.w,
                    imageUrl: brand.logo,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 160.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10.r,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                top: ratingTop ?? 10.h,
                end: ratingEnd ?? 10.w,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetsManager.star,
                      height: 12.r,
                      width: 12.r,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    DText(
                      brand.rating!.toStringAsFixed(1),
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PositionedDirectional(
                bottom: infoBottom ?? 10.h,
                start: infoStart ?? 10.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        DText(
                          brand.name.length > 15
                              ? '${brand.name.substring(0, 15)}...'
                              : brand.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: nameStyle ??
                              context.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        SizedBox(width: 8.w),
                        if (brand.verified)
                          Icon(
                            SolarIconsBold.verifiedCheck,
                            color: context.colorScheme.primary,
                            size: 14.r,
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6).r,
                      child: Container(
                        width: 100.w,
                        height: 1.5.h,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          SolarIconsOutline.usersGroupTwoRounded,
                          size: 12.r,
                          color: context.colorScheme.onPrimary,
                        ),
                        SizedBox(width: 4.w),
                        DText(
                          "${brand.totalBookingsCount.toString()} ${context.tr.clients}",
                          style: context.textTheme.labelSmall!.copyWith(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

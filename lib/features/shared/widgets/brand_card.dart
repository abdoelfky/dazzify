import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.brand,
    required this.onTap,
  });

  final BrandModel brand;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          ClipOval(
            child: DazzifyCachedNetworkImage(
              height: 60.r,
              width: 60.r,
              imageUrl: brand.logo,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: context.screenWidth * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 180.w),
                      child: IntrinsicWidth(
                          child: DText(
                        maxLines: 1,
                        brand.name,
                        style: context.textTheme.bodyMedium,
                      )),
                    ),
                    SizedBox(width: 8.w),
                    if (brand.verified)
                      Icon(
                        SolarIconsBold.verifiedCheck,
                        color: context.colorScheme.primary,
                        size: 14.r,
                      )
                  ],
                ),
                DText(
                  brand.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                DText(

                  '${context.tr.priceRange} : ${reformatPriceWithCommas(brand.minPrice!)} ${context.tr.egp} - ${reformatPriceWithCommas(brand.maxPrice!)} ${context.tr.egp}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelSmall!.copyWith(
                    color: context.colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: context.screenWidth * 0.11,
            child: Column(
              children: [
                Row(
                  children: [
                    DText(
                      '${brand.totalBookingsCount}',
                      style: context.textTheme.bodySmall!
                          .copyWith(color: context.colorScheme.outline),
                    ),
                    const Spacer(),
                    Icon(
                      SolarIconsOutline.usersGroupTwoRounded,
                      size: 12.r,
                      color: context.colorScheme.outline,
                    )
                  ],
                ),
                Row(
                  children: [
                    DText(
                      brand.rating!.toString(),
                      style: context.textTheme.bodySmall!
                          .copyWith(color: context.colorScheme.outline),
                    ),
                    const Spacer(),
                    Icon(
                      SolarIconsOutline.star,
                      size: 12.r,
                      color: context.colorScheme.outline,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.brand,
    required this.onTap,
    this.hasAvailability,
    this.availabilityLabel,
  });

  final BrandModel brand;
  final void Function() onTap;
  /// When true, show that the brand is available at the user's selected time (e.g. recommendation results).
  final bool? hasAvailability;
  /// Label to show when [hasAvailability] is true (e.g. "Available at your selected time").
  final String? availabilityLabel;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: DText(
                        brand.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium,
                      ),
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
                if (hasAvailability == true && (availabilityLabel != null && availabilityLabel!.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(top: 4).r,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2).r,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6).r,
                      ),
                      child: DText(
                        availabilityLabel!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelSmall!.copyWith(
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                if (brand.description != null && brand.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4).r,
                    child: DText(
                      brand.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4).r,
                  child: DText(
                    '${context.tr.priceRange} : ${reformatPriceWithCommas(brand.minPrice!)} ${context.tr.egp} - ${reformatPriceWithCommas(brand.maxPrice!)} ${context.tr.egp}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: context.colorScheme.primaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          if ((brand.totalBookingsCount != null && brand.totalBookingsCount! > 0) || (brand.rating != null && !(brand.rating == 0 && (brand.ratingCount ?? 0) == 0)))
            SizedBox(
              width: context.screenWidth * 0.11,
              child: Column(
                children: [
                  if (brand.totalBookingsCount != null && brand.totalBookingsCount! > 0)
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
                  if (brand.rating != null && !(brand.rating == 0 && (brand.ratingCount ?? 0) == 0))
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

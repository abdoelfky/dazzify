import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class PopularBrandCard extends StatelessWidget {
  final BrandModel brand;
  final void Function()? onTap;

  const PopularBrandCard({
    super.key,
    required this.brand,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260.w,
        height: 95.h,
        decoration: BoxDecoration(
          color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16).r,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8).r,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16).r,
                child: DazzifyCachedNetworkImage(
                  height: 80.h,
                  width: 58.w,
                  imageUrl: brand.logo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0).r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width:170.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 175.w,
                    child: DText(
                      brand.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  DText(

                    '${context.tr.priceRange} : ${reformatPriceWithCommas(brand.minPrice!)} ${context.tr.egp} - ${reformatPriceWithCommas(brand.maxPrice!)} ${context.tr.egp}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: context.colorScheme.primaryContainer,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        SolarIconsOutline.usersGroupTwoRounded,
                        size: 12.r,
                        color: context.colorScheme.outline,
                      ),
                      SizedBox(width: 4.w),
                      DText(
                        brand.totalBookingsCount.toString(),
                        style: context.textTheme.bodySmall!
                            .copyWith(color: context.colorScheme.outline),
                      ),
                      SizedBox(width: 24.w),
                      Icon(
                        SolarIconsOutline.star,
                        size: 12.r,
                        color: context.colorScheme.outline,
                      ),
                      SizedBox(width: 4.w),
                      DText(
                        brand.rating!.toString(),
                        style: context.textTheme.bodySmall!
                            .copyWith(color: context.colorScheme.outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

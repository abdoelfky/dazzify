import 'dart:ui';

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';

class TopRatedServiceCard extends StatelessWidget {
  final String title;
  final String image;
  final void Function() onTap;
  final BorderRadiusGeometry? borderRadius;
  final void Function()? onFavoriteTap;
  final bool? isFavorite;
  final double? height;
  final double? width;
  final num price;
  final num? originalPrice;

  const TopRatedServiceCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    required this.price,
    this.originalPrice,
    this.onFavoriteTap,
    this.isFavorite,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20).r,
        child: Stack(
          children: [
            DazzifyCachedNetworkImage(
              imageUrl: image,
              width: width ?? 150.w,
              height: height ?? 190.h,
              fit: BoxFit.cover,
            ),
            PositionedDirectional(
              bottom: 0,
              child: SizedBox(
                width: 160.w,
                height: 56.h,
                child: Stack(
                  children: [
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 14,
                          sigmaY: 14,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 16.0.r,
                        bottom: 4.r,
                      ),
                      child: SizedBox(
                        width: 80.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DText(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            _buildPriceWidget(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (onFavoriteTap != null)
              PositionedDirectional(
                top: 10.h,
                end: 10.w,
                child: FavoriteIconButton(
                  iconSize: 18.r,
                  backgroundColor:
                      context.colorScheme.onPrimary.withValues(alpha: 0.6),
                  favoriteColor: context.colorScheme.primary,
                  unFavoriteColor: context.colorScheme.primary,
                  isFavorite: isFavorite!,
                  onFavoriteTap: onFavoriteTap!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceWidget(BuildContext context) {
    final hasOffer = originalPrice != null && 
                     originalPrice! > 0 && 
                     originalPrice! > price;

    if (hasOffer) {
      // Case 2: There's an offer - show price and originalPrice with strikethrough
      return Row(
        children: [
          DText(
            '${reformatPriceWithCommas(price)} ${context.tr.egp}',
            style: context.textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(width: 4.w),
          DText(
            '${reformatPriceWithCommas(originalPrice!)} ${context.tr.egp}',
            style: context.textTheme.bodySmall!.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    } else {
      // Case 1: No offer - show only price
      return DText(
        '${reformatPriceWithCommas(price)} ${context.tr.egp}',
        style: context.textTheme.bodySmall!.copyWith(
          color: Colors.white,
        ),
      );
    }
  }
}

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';

class FavoriteCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final double? imageHeight;
  final double? imageWidth;
  final double? borderRadius;
  final void Function() onFavoriteTap;
  final void Function() onTap;
  final bool isFavorite;
  final double? bottom;

  const FavoriteCard({
    required this.image,
    required this.title,
    required this.price,
    required this.onFavoriteTap,
    required this.onTap,
    required this.isFavorite,
    super.key,
    this.imageHeight,
    this.imageWidth,
    this.borderRadius,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 107.w,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius ?? 20).r,
                    child: DazzifyCachedNetworkImage(
                      width: imageWidth ?? 104.w,
                      height: imageHeight ?? 116.h,
                      imageUrl: image,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  height: 9.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 9.w,
                    ),
                    SizedBox(
                      width: 95.w,
                      child: DText(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 9.w,
                    ),
                    SizedBox(
                      width: 95.w,
                      child: DText(
                        price,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                )
              ],
            ),
            PositionedDirectional(
              bottom: bottom ?? 50.h,
              end: 0,
              child: FavoriteIconButton(
                iconSize: 22.r,
                backgroundColor: context.colorScheme.surface,
                favoriteColor: context.colorScheme.primary,
                unFavoriteColor: context.colorScheme.primary,
                isFavorite: isFavorite,
                onFavoriteTap: onFavoriteTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

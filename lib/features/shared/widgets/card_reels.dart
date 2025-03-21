import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class CardReels extends StatelessWidget {
  final String thumbnailUrl;
  final int? viewCount;
  final double? bottom;
  final double? left;
  final double? width;
  final void Function()? onTap;

  const CardReels({
    super.key,
    required this.thumbnailUrl,
    required this.viewCount,
    this.bottom,
    this.left,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: DazzifyCachedNetworkImage(
              imageUrl: thumbnailUrl,
              height: 180.h,
              width: width ?? 150.w,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: bottom ?? 20.h,
            left: left ?? 8.w,
            child: Row(
              children: [
                Icon(
                  SolarIconsBold.play,
                  size: 15.r,
                  color: Colors.white,
                ),
                SizedBox(width: 5.w),
                viewCount != null
                    ? DText(
                        viewCount.toString(),
                        style: context.textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    required this.imageUrl,
    required this.onTap,
    required this.isVideo,
    this.viewsCount,
    super.key,
    required this.isAlbum,
  });

  final String imageUrl;
  final void Function() onTap;
  final bool isVideo;
  final bool isAlbum;
  final int? viewsCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8).r,
        child: SizedBox(
            height: isVideo ? 228.r : 110.r,
            width: 130.r,
            child: Stack(
              children: [
                DazzifyCachedNetworkImage(
                  imageUrl: imageUrl,
                  height: isVideo ? 228.r : 110.r,
                  width: 130.r,
                  fit: BoxFit.cover,
                ),
                if (isVideo)
                  Positioned(
                      left: 8.r,
                      bottom: 16.r,
                      child: Row(
                        children: [
                          Icon(
                            SolarIconsBold.play,
                            size: 12.r,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8.r,
                          ),
                          DText(
                            viewsCount == null ? '' : viewsCount.toString(),
                            style: context.textTheme.labelSmall!
                                .copyWith(color: Colors.white),
                          )
                        ],
                      )),
                if (isAlbum)
                  Positioned(
                    right: 3.w,
                    top: 3.h,
                    child: Icon(
                      SolarIconsOutline.album,
                      color: context.colorScheme.primary,
                      size: 16.r,
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}

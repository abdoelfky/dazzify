import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/helper/map_helper.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class BookingInfoItem extends StatelessWidget {
  final String? imageUrl;
  final double? imageHeight;
  final double? imageWidth;
  final IconData? icon;
  final double? iconSize;
  final String title;
  final String subtitle;
  final bool isImage;
  final bool? hasLocationData;
  final double? lat;
  final double? long;
  final bool? isVerified;

  const BookingInfoItem({
    super.key,
    this.icon,
    this.iconSize,
    required this.title,
    required this.subtitle,
    required this.isImage,
    this.imageUrl,
    this.imageHeight,
    this.imageWidth,
    this.hasLocationData,
    this.lat,
    this.long,
    this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(360).r,
                child: DazzifyCachedNetworkImage(
                  imageUrl: imageUrl!,
                  height: imageHeight ?? 24.h,
                  width: imageWidth ?? 24.w,
                ),
              )
            : Icon(icon, size: iconSize ?? 18.sp),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DText(
                  title,
                  style: context.textTheme.bodyMedium,
                ),
                if (isVerified != null && isVerified!)
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 4.0),
                    child: Icon(
                      SolarIconsBold.verifiedCheck,
                      color: context.colorScheme.primary,
                      size: 15.r,
                    ),
                  )
              ],
            ),
            SizedBox(height: 6.h),
            hasLocationData == true
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 160.w,
                        child: DText(
                          subtitle,
                          overflow: null,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          MapHelper.openLocation(lat: lat!, long: long!);
                        },
                        child: DText(
                          context.tr.viewOnMap,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                  width: 200.w,
                  child: DText(
                      subtitle,
                      overflow: null,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ),
          ],
        ),
      ],
    );
  }
}

import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class CardImage extends StatelessWidget {
  final int index;
  final String imageUrl;
  final bool isAlbum;
  final void Function()? onTap;
  final String? aspectRatio;

  const CardImage({
    super.key,
    required this.index,
    required this.imageUrl,
    this.onTap,
    required this.isAlbum,
    this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10).r,
            child: Hero(
              tag: index,
              child: DazzifyCachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
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
    );
  }
}

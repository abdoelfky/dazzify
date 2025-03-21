import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class DazzifyRoundedPicture extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool hasEditButton;
  final void Function()? onEditButtonTap;

  const DazzifyRoundedPicture({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.hasEditButton = false,
    this.onEditButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return hasEditButton
        ? SizedBox(
            width: 110.r,
            height: 110.r,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipOval(
                    child: imageUrl == '' || imageUrl == null
                        ? Image.asset(
                            AssetsManager.avatar,
                            fit: BoxFit.contain,
                          )
                        : DazzifyCachedNetworkImage(
                            key: key,
                            imageUrl: imageUrl!,
                            fit: fit ?? BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditButtonTap,
                    child: Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        SolarIconsOutline.pen,
                        size: 10.r,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : ClipOval(
            child: imageUrl == '' || imageUrl == null
                ? Image.asset(
                    AssetsManager.avatar,
                    width: 100.r,
                    height: 100.r,
                    fit: BoxFit.contain,
                  )
                : DazzifyCachedNetworkImage(
                    key: key,
                    imageUrl: imageUrl!,
                    width: width ?? 42.r,
                    height: height ?? 42.r,
                    fit: fit ?? BoxFit.cover,
                  ),
          );
  }
}

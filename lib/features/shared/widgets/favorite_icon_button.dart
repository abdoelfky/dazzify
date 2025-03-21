import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class FavoriteIconButton extends StatelessWidget {
  final bool isFavorite;
  final void Function() onFavoriteTap;
  final bool hasBackGround;
  final double? iconSize;
  final double? backgroundWidth;
  final double? backgroundHeight;
  final double? backgroundOpacity;
  final double? borderRadius;
  final Color? unFavoriteColor;
  final Color? favoriteColor;
  final Color? backgroundColor;

  const FavoriteIconButton({
    super.key,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.hasBackGround = true,
    this.iconSize,
    this.backgroundHeight,
    this.backgroundWidth,
    this.backgroundOpacity,
    this.borderRadius,
    this.unFavoriteColor,
    this.favoriteColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return hasBackGround
        ? Container(
            width: backgroundWidth ?? 30.r,
            height: backgroundHeight ?? 30.r,
            decoration: BoxDecoration(
                color: backgroundColor ??
                    Colors.white.withValues(alpha: backgroundOpacity ?? 0.5),
                borderRadius: BorderRadius.circular(borderRadius ?? 20).r),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  key: ValueKey<bool>(isFavorite),
                  onPressed: onFavoriteTap,
                  icon: isFavorite
                      ? Icon(
                          SolarIconsBold.heart,
                          color: favoriteColor ?? context.colorScheme.primary,
                          size: iconSize ?? 20.r,
                        )
                      : Icon(
                          SolarIconsOutline.heart,
                          color: unFavoriteColor ?? context.colorScheme.primary,
                          size: iconSize ?? 20.r,
                        ),
                ),
              ),
            ),
          )
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: IconButton(
              padding: EdgeInsets.zero,
              key: ValueKey<bool>(isFavorite),
              onPressed: onFavoriteTap,
              icon: isFavorite
                  ? Icon(
                      SolarIconsBold.heart,
                      color: favoriteColor ?? context.colorScheme.primary,
                      size: iconSize ?? 20.r,
                    )
                  : Icon(
                      SolarIconsOutline.heart,
                      color: unFavoriteColor ?? context.colorScheme.primary,
                      size: iconSize ?? 20.r,
                    ),
            ),
          );
  }
}

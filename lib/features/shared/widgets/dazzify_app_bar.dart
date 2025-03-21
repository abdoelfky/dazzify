import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class DazzifyAppBar extends StatelessWidget {
  final String? title;
  final double? horizontalPadding;
  final double? verticalPadding;
  final void Function()? onBackTap;
  final TextStyle? textStyle;
  final bool isLeading;

  const DazzifyAppBar({
    super.key,
    this.title,
    this.horizontalPadding,
    this.verticalPadding,
    this.onBackTap,
    this.textStyle,
    required this.isLeading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding ?? 12,
        right: horizontalPadding ?? 12,
        top: verticalPadding ?? 2,
        bottom: verticalPadding ?? 2,
      ).r,
      child: Row(
        children: [
          isLeading
              ? IconButton(
                  onPressed: onBackTap ??
                      () {
                        context.maybePop();
                      },
                  icon: Icon(
                    context.currentTextDirection == TextDirection.ltr
                        ? SolarIconsOutline.arrowLeft
                        : SolarIconsOutline.arrowRight,
                    size: 22.r,
                  ),
                )
              : Container(),
          title != null ? SizedBox(width: 8.w) : const SizedBox.shrink(),
          title != null
              ? DText(title!, style: textStyle ?? context.textTheme.titleMedium)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

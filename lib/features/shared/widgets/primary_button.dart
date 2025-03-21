import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class PrimaryButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String title;
  final TextStyle? titleStyle;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Color? color;
  final Color? textColor;
  final void Function() onTap;
  final bool isOutLined;
  final bool isActive;
  final bool isLoading;
  final int flexBetweenTextAndPrefix;
  final BorderRadiusGeometry? borderRadius;

  const PrimaryButton({
    super.key,
    required this.onTap,
    this.height,
    this.width,
    required this.title,
    this.titleStyle,
    this.prefixWidget,
    this.suffixWidget,
    this.color,
    this.textColor,
    this.isOutLined = false,
    this.isActive = true,
    this.isLoading = false,
    this.flexBetweenTextAndPrefix = 3,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        width: width ?? 312.w,
        height: height ?? 42.h,
        decoration: BoxDecoration(
          color: isOutLined
              ? Colors.transparent
              : color ??
                  (isActive
                      ? context.colorScheme.primary
                      : context.colorScheme.primary.withValues(alpha: 0.4)),
          border: isOutLined
              ? Border.all(color: color ?? context.colorScheme.primary)
              : null,
          borderRadius: borderRadius ?? BorderRadius.circular(10).r,
        ),
        child: prefixWidget != null || suffixWidget != null
            ? Padding(
                padding: const EdgeInsets.all(8.0).r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Spacer(flex: 4),
                    prefixWidget ?? SizedBox.shrink(),
                    Spacer(flex: flexBetweenTextAndPrefix),
                    isLoading
                        ? loadingAnimation(context)
                        : buildButtonDText(context),
                    suffixWidget ?? SizedBox.shrink(),
                    const Spacer(flex: 4),
                  ],
                ),
              )
            : Center(
                child: isLoading
                    ? loadingAnimation(context)
                    : buildButtonDText(context)),
      ),
    );
  }

  DText buildButtonDText(BuildContext context) {
    return DText(
      title,
      style: titleStyle ??
          context.textTheme.labelLarge!.copyWith(
            color: textColor ??
                (isOutLined
                    ? context.colorScheme.primary
                    : context.colorScheme.onPrimary),
          ),
    );
  }

  Widget loadingAnimation(BuildContext context) {
    if (context.isDarkTheme && !isOutLined) {
      return Lottie.asset(
        AssetsManager.loadingDark,
        height: 300.w,
        width: 300.h,
      );
    } else if (!context.isDarkTheme && !isOutLined) {
      return Lottie.asset(
        AssetsManager.loadingLight,
        height: 300.w,
        width: 300.h,
      );
    } else {
      return const SizedBox(
        height: 20,
        child: LoadingAnimation(
          height: 20,
        ),
      );
    }
  }
}

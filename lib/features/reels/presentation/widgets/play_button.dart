import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class PlayButton extends StatelessWidget {
  final Color? iconColor;
  final void Function() onPressed;
  final double? iconSize;
  final IconData? icon;
  final Duration? animationDuration;

  const PlayButton({
    super.key,
    this.iconColor,
    required this.onPressed,
    this.iconSize,
    this.icon,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFadeAnimation(
      duration: animationDuration ?? const Duration(milliseconds: 300),
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: iconColor ?? context.colorScheme.primary.withValues(alpha: 0.8),
        onPressed: onPressed,
        icon: Icon(
          icon ?? SolarIconsBold.play,
          size: iconSize ?? 70.r,
        ),
      ),
    );
  }
}

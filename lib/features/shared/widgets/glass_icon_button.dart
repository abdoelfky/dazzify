import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlassIconButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData? icon;
  final String? svgIconPath;
  final double? iconSize;
  final double? width;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  const GlassIconButton(
      {super.key,
      required this.onPressed,
      this.icon,
      this.svgIconPath,
      this.iconSize,
      this.width,
      this.height,
      this.radius,
      this.backgroundColor,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: width ?? 40.w,
      height: height ?? 44.h,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
        borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 10).r,
      ),
      child: icon != null
          ? IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Colors.white,
                size: iconSize ?? 24.r,
              ),
            )
          : GestureDetector(
              onTap: onPressed,
              child: SizedBox(
                width: 24.r,
                height: 24.r,
                child: SvgPicture.asset(
                  svgIconPath!,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
    );
  }
}

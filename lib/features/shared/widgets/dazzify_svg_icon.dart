import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DazzifySvgIcon extends StatelessWidget {
  final String svgIconPath;
  final BoxFit? boxFit;
  final double? width;
  final double? height;
  final Color? color;

  const DazzifySvgIcon({
    super.key,
    required this.svgIconPath,
    this.boxFit,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).r,
      child: SvgPicture.asset(
        svgIconPath,
        width: width ?? 30.r,
        height: height ?? 30.r,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}

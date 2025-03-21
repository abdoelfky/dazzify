import 'dart:ui';

import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';

class NeonLightPainter extends StatelessWidget {
  const NeonLightPainter({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 50,
        sigmaY: 50,
        tileMode: TileMode.decal,
      ),
      child: Container(
        width: context.screenWidth * 0.75,
        height: context.screenWidth * 0.75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

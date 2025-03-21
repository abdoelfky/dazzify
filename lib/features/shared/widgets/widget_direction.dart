import 'dart:math' as math;

import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';

class WidgetDirection extends StatelessWidget {
  final Widget child;

  const WidgetDirection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      double transformY = context.isEnglishLanguage ? 0 : math.pi;
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(transformY),
        child: child,
      );
    });
  }
}

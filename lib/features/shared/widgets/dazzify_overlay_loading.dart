import 'dart:ui';

import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:flutter/material.dart';

class DazzifyOverlayLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final double? blurXy;

  const DazzifyOverlayLoading({
    required this.child,
    required this.isLoading,
    super.key,
    this.blurXy,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurXy ?? 20,
                  sigmaY: blurXy ?? 20,
                ),
                child: Container(
                  width: context.screenWidth,
                  height: context.screenHeight,
                  color: Colors.transparent,
                ),
              )
            : const SizedBox.shrink(),
        isLoading
            ? const Positioned.fill(child: LoadingAnimation())
            : const SizedBox.shrink(),
      ],
    );
  }
}

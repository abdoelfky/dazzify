import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  final double? width;
  final double? height;

  const LoadingAnimation({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Builder(
        builder: (context) {
          if (context.isDarkTheme) {
            return Lottie.asset(AssetsManager.loadingDarkLarge,
                width: width ?? 150.w, height: height ?? 150.h);
          } else {
            return Lottie.asset(AssetsManager.loadingLightLarge,
                width: width ?? 150.w, height: height ?? 150.h);
          }
        },
      ),
    );
  }
}

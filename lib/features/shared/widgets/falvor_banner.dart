import 'package:dazzify/core/config/build_config.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:flutter/material.dart';

class BuildFlavorBanner extends StatelessWidget {
  final Widget child;

  const BuildFlavorBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (getIt<BuildConfig>().env == CustomEnv.prod) return child;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Builder(
        builder: (context) {
          return Stack(
            fit: StackFit.expand,
            children: [child, _buildBanner(context)],
          );
        },
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
            message: getIt<BuildConfig>().env,
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.topStart,
            color: getIt<BuildConfig>().env == CustomEnv.dev
                ? const Color(0xff3DDC84)
                : const Color(0xfffcc000)),
      ),
    );
  }
}

import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/auth/presentation/widgets/auth_shape_clipper.dart';
import 'package:dazzify/settings/theme/colors_scheme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class AuthHeader extends StatelessWidget {
  final bool isLogoAnimated;

  const AuthHeader({super.key, this.isLogoAnimated = false});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AuthShapeClipper(),
      child: Container(
        width: context.screenWidth,
        height: 242.h,
        color: ColorsSchemeManager.light.primary,
        child: Center(
          child: isLogoAnimated
              ? Lottie.asset(repeat: false, AssetsManager.dazzifyAuthLogo)
              : SvgPicture.asset(AssetsManager.appLogo),
        ),
      ),
    );
  }
}

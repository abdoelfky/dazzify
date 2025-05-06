import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:flutter_svg/svg.dart';

class EmptyDataWidget extends StatelessWidget {
  final String message;
  final double? width;
  final double? height;
  final TextStyle? messageStyle;
  final String? svgIconPath;

  const EmptyDataWidget({
    super.key,
    required this.message,
    this.height,
    this.width,
    this.messageStyle,
    this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFadeAnimation(
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgIconPath ?? AssetsManager.smilingFace,
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
            width: width ?? 80.w,
            height: height ?? 78.h,
          ),
          SizedBox(height: 30.h),
          DText(
            message,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: messageStyle ??
                context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/glass_icon_button.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/shared/widgets/widget_direction.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorDataWidget extends StatefulWidget {
  final DazzifyErrorDataType errorDataType;
  final void Function()? onTap;
  final String message;
  final bool enableBackIcon;

  const ErrorDataWidget({
    super.key,
    required this.onTap,
    required this.errorDataType,
    required this.message,
    this.enableBackIcon = false,
  });

  @override
  State<ErrorDataWidget> createState() => _ErrorDataWidgetState();
}

class _ErrorDataWidgetState extends State<ErrorDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomFadeAnimation(
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: SingleChildScrollView(
              child: buildErrorDataWidget(
                context: context,
                onTap: widget.onTap,
                errorDataType: widget.errorDataType,
                message: widget.message,
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 50,
          start: 20,
          child: Visibility(
            visible: widget.enableBackIcon,
            child: WidgetDirection(
              child: GlassIconButton(
                icon: SolarIconsOutline.arrowLeft,
                onPressed: () {
                  context.maybePop();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildErrorDataWidget({
    required BuildContext context,
    required void Function()? onTap,
    required String message,
    required DazzifyErrorDataType errorDataType,
  }) {
    switch (errorDataType) {
      case DazzifyErrorDataType.screen:
        return buildScreenErrorData(context, onTap, message);
      case DazzifyErrorDataType.sheet:
        return buildSheetErrorData(context, onTap, message);
    }
  }

  Widget buildScreenErrorData(
      BuildContext context, void Function()? onTap, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AssetsManager.error,
          ),
          SizedBox(height: 30.h),
          DText(
            context.tr.oops,
            style: context.textTheme.headlineMedium,
          ),
          SizedBox(height: 16.h),
          DText(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 80.h),
          if (widget.onTap != null)
            PrimaryButton(
              onTap: onTap!,
              title: context.tr.retry,
              height: 42.h,
            ),
        ],
      ),
    );
  }

  Widget buildSheetErrorData(
      BuildContext context, void Function()? onTap, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AssetsManager.error,
            height: 150.h,
            width: 150.w,
          ),
          SizedBox(height: 30.h),
          DText(
            context.tr.oops,
            style: context.textTheme.headlineMedium,
          ),
          SizedBox(height: 16.h),
          DText(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 80.h),
          if (onTap != null)
            PrimaryButton(
              onTap: onTap,
              title: context.tr.retry,
              height: 42.h,
            ),
        ],
      ),
    );
  }
}

enum DazzifyErrorDataType { screen, sheet }

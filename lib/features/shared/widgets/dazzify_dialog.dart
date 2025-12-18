import 'dart:ui';

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class DazzifyDialog extends StatelessWidget {
  final String message;
  final String buttonTitle;
  final Future<void> Function() onTap;
  final VoidCallback? onCancelTap;

  const DazzifyDialog({
    super.key,
    required this.message,
    required this.buttonTitle,
    required this.onTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: CustomFadeAnimation(
        duration: const Duration(milliseconds: 500),
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(
            vertical: 260,
            horizontal: 0,
          ).r,
          child: Container(
            width: context.screenWidth * 0.9,
            height: 200.h,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(16).r,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 221.w,
                  child: DText(
                    message,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 36.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryButton(
                        onTap: () {
                          onCancelTap?.call();
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (context.mounted) {
                              context.maybePop();
                            }
                          });
                        },
                        width: 145.w,
                        height: 42.h,
                        title: context.tr.cancel,
                        isOutLined: true,
                      ),
                      const Spacer(),
                      PrimaryButton(
                        onTap: onTap,
                        width: 145.w,
                        height: 42.h,
                        title: buttonTitle,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

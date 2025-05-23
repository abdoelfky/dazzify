import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/logic/settings/check_for_app_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'primary_button.dart';

class DazzifyUpdateDialog extends StatelessWidget {
  final String message;
  final String buttonTitle;
  final Future<void> Function() onTap;
  final bool isCancelable; // ✅ NEW

  const DazzifyUpdateDialog({
    super.key,
    required this.message,
    required this.buttonTitle,
    required this.onTap,
    this.isCancelable = true,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: CustomFadeAnimation(
        duration: const Duration(milliseconds: 500),
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 260).r,
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
                DText(
                  message,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge,
                ),
                SizedBox(height: 36.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isCancelable)
                        PrimaryButton(
                          onTap: () async{
                            await UpdatePostponeManager.markPostponedNow();

                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (context.mounted) {
                                context.maybePop();
                              }
                            });
                          },
                          width: 145.w,
                          height: 42.h,
                          title: context.tr.later,
                          isOutLined: true,
                        ),
                      if (isCancelable) const Spacer(),
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

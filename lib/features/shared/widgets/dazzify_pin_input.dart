import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class DazzifyPinInput extends StatelessWidget {
  final DazzifyPinState dazzifyPinState;
  final void Function(String) onPinEntered;

  const DazzifyPinInput({
    super.key,
    required this.dazzifyPinState,
    required this.onPinEntered,
  });

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: AppConstants.otpLength,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      forceErrorState: dazzifyPinState == DazzifyPinState.error,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "";
        } else {
          return null;
        }
      },
      defaultPinTheme: PinTheme(
        width: 40.w,
        height: 40.w,
        textStyle: context.textTheme.bodyLarge!.copyWith(
          color: dazzifyPinState == DazzifyPinState.success
              ? ColorsManager.successColor
              : context.colorScheme.outline,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: dazzifyPinState == DazzifyPinState.success
                ? ColorsManager.successColor
                : context.colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ).r,
        ),
      ),
      errorPinTheme: PinTheme(
        width: 40.w,
        height: 40.w,
        textStyle: context.textTheme.bodySmall!.copyWith(
          color: context.colorScheme.outline,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.errorContainer,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)).r,
        ),
      ),
      onCompleted: onPinEntered,
    );
  }
}

enum DazzifyPinState { normal, error, success }

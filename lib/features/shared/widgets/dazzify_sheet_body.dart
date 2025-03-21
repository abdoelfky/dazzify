import 'dart:ui';

import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/bottom_sheet_dash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DazzifySheetBody extends StatelessWidget {
  final String? title;
  final double? height;
  final List<Widget> children;
  final double? handlerWidth;
  final double? handlerHeight;
  final Color? handlerColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? titleBottomPadding;
  final bool enableBottomInsets;

  const DazzifySheetBody({
    super.key,
    this.title,
    this.height,
    this.handlerWidth,
    this.handlerHeight,
    this.handlerColor,
    this.backgroundColor,
    required this.children,
    this.textStyle,
    this.titleBottomPadding,
    this.enableBottomInsets = false,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: height ?? context.screenHeight * 0.75,
        width: context.screenWidth,
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ).r,
        ),
        child: Padding(
          padding: enableBottomInsets
              ? EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                )
              : EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetDash(
                height: handlerHeight ?? 6.h,
                width: handlerWidth ?? 70.w,
                color: handlerColor ?? context.colorScheme.primary,
              ),
              SizedBox(height: 13.h),
              if (title != null)
                DText(
                  title!,
                  style: textStyle ??
                      context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                ),
              SizedBox(height: titleBottomPadding ?? 20.h),
              ...children
            ],
          ),
        ),
      ),
    );
  }
}

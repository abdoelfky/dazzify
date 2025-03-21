import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermCheckBox extends StatelessWidget {
  final void Function() onBoxTap;
  final bool isChecked;

  const TermCheckBox({
    required this.onBoxTap,
    required this.isChecked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onBoxTap();
        },
        child: AnimatedContainer(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.w,
              color: isChecked
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant,
            ),
            shape: BoxShape.circle,
          ),
          duration: const Duration(
            milliseconds: 500,
          ),
          curve: Curves.easeInOut,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 500,
              ),
              curve: Curves.easeInOut,
              width: 7.w,
              height: 7.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked
                    ? context.colorScheme.primary
                    : Colors.transparent,
              ),
            ),
          ),
        ));
  }
}

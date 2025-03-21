import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpperDash extends StatelessWidget {
  const UpperDash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(8).r,
      ),
    );
  }
}

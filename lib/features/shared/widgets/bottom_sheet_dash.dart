import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetDash extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;

  const BottomSheetDash({super.key, this.color, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8).r,
      ),
    );
  }
}

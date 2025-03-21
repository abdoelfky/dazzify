import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DottedLine extends StatefulWidget {
  final double lineWidth;
  final Color lineColor;

  const DottedLine({
    required this.lineWidth,
    required this.lineColor,
    super.key,
  });

  @override
  State<DottedLine> createState() => _DottedLineState();
}

class _DottedLineState extends State<DottedLine> {
  final double dashWidth = 6.w;
  final double dashHeight = 1.5.h;
  late int dashesNumber;

  @override
  void initState() {
    dashesNumber = (widget.lineWidth / (2 * dashWidth)).floor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        dashesNumber,
        (index) => Container(
          width: dashWidth,
          height: dashHeight,
          color: widget.lineColor,
        ),
      ),
    );
  }
}

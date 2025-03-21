import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';

class DText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final double? minFontSize;
  final TextOverflow? overflow;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextAlign? textAlign;

  const DText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.minFontSize,
    this.overflow = TextOverflow.ellipsis,
    this.textDirection,
    this.softWrap,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? context.textTheme.bodySmall,
      maxLines: maxLines ?? 1,
      textDirection: textDirection,
      // minFontSize: minFontSize ?? 13.0,
      softWrap: softWrap,
      textAlign: textAlign,
      overflow: overflow!,
    );
  }
}

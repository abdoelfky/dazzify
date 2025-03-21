import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedReadMoreText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final String moreText;
  final String lessText;
  final TextStyle? linkStyle;
  final int trimLines;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedReadMoreText({
    super.key,
    required this.text,
    this.textStyle,
    this.moreText = "Read more",
    this.lessText = "Read less",
    this.linkStyle,
    this.trimLines = 2,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<AnimatedReadMoreText> createState() => _AnimatedReadMoreTextState();
}

class _AnimatedReadMoreTextState extends State<AnimatedReadMoreText>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: widget.text,
      style: widget.textStyle ?? DefaultTextStyle.of(context).style,
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    final isTextOverflowing = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          child: DText(
            widget.text,
            style: widget.textStyle ?? DefaultTextStyle.of(context).style,
            maxLines: _isExpanded ? null : widget.trimLines,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
        if (isTextOverflowing)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0).r,
              child: DText(
                _isExpanded ? widget.lessText : widget.moreText,
                style: widget.linkStyle ??
                    TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

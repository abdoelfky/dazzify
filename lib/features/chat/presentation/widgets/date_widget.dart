import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({required this.date, super.key});

  final String date;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).r,
      child: Text(
        date,
        textAlign: TextAlign.center,
        style: context.textTheme.bodySmall!
            .copyWith(color: context.colorScheme.primaryContainer),
      ),
    );
  }
}

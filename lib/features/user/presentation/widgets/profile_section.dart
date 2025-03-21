import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSection extends StatelessWidget {
  final String sectionTitle;
  final Widget children;
  final EdgeInsets? margin;

  const ProfileSection({
    super.key,
    required this.sectionTitle,
    required this.children,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.only(top: 16.0).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionWidget(
            sectionTitle: sectionTitle,
            padding: EdgeInsets.zero,
          ),
          SizedBox(height: 8.h),
          Container(
            width: 328.h,
            decoration: BoxDecoration(
              color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: children,
          ),
        ],
      ),
    );
  }
}

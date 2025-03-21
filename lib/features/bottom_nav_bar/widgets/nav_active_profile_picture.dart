import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_rounded_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavActiveProfilePicture extends StatelessWidget {
  final String imagePath;

  const NavActiveProfilePicture({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0).r,
        child: DazzifyRoundedPicture(
          imageUrl: imagePath,
          width: 30.r,
          height: 30.r,
        ),
      ),
    );
  }
}

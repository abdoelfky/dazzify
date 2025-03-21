import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandCategoryItem extends StatelessWidget {
  final String name, image;
  final void Function() onTap;
  final bool isSelected;

  const BrandCategoryItem({
    super.key,
    required this.name,
    required this.image,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 8),
        key: key,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected ? context.colorScheme.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: DazzifyCachedNetworkImage(
                width: 30.h,
                height: 30.h,
                imageUrl: image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8),
            DText(
              name,
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

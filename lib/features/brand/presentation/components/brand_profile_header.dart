import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/presentation/components/brand_info.dart';
import 'package:dazzify/features/brand/presentation/widgets/brand_cover_shape_clipper.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandProfileHeader extends StatelessWidget {
  final BrandModel brand;

  const BrandProfileHeader({
    super.key,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      width: context.screenWidth,
      child: Stack(
        children: [
          ClipPath(
            clipper: BrandProfileCoverClipper(),
            child: SizedBox(
              width: context.screenWidth,
              height: 263.h,
              child: DazzifyCachedNetworkImage(
                imageUrl: brand.bannerUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          BrandInfo(
            brand: brand,
          ),
        ],
      ),
    );
  }
}

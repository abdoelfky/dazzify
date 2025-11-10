import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class LoadingMessageShimmer extends StatelessWidget {
  final bool isTextMessage;
  
  const LoadingMessageShimmer({
    super.key,
    this.isTextMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Shimmer.fromColors(
              baseColor: context.colorScheme.primary.withOpacity(0.3),
              highlightColor: context.colorScheme.primary.withOpacity(0.1),
              child: Container(
                width: isTextMessage ? 150.w : 230.w,
                height: isTextMessage ? 50.h : 200.h,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withOpacity(0.5),
                  borderRadius: isTextMessage
                      ? BorderRadiusDirectional.only(
                          topStart: const Radius.circular(40).r,
                          topEnd: const Radius.circular(40).r,
                          bottomStart: Radius.circular(40.r),
                        )
                      : const BorderRadius.all(
                          Radius.circular(16),
                        ).r,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Shimmer.fromColors(
              baseColor: context.colorScheme.primaryContainer.withOpacity(0.3),
              highlightColor: context.colorScheme.primaryContainer.withOpacity(0.1),
              child: Container(
                width: 50.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4).r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

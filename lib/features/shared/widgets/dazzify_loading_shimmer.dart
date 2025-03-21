import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DazzifyLoadingShimmer extends StatelessWidget {
  final DazzifyLoadingType dazzifyLoadingType;
  final int? crossAxisCount;
  final double? mainAxisExtent;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final BorderRadiusGeometry? borderRadius;
  final double? cardWidth;
  final double? cardHeight;
  final double? separatorHeight;
  final double? separatorWidth;
  final EdgeInsetsGeometry? widgetPadding;
  final EdgeInsetsGeometry? itemPadding;
  final Widget? children;
  final Axis? scrollDirection;
  final int? gridViewItemCount;
  final int? listViewItemCount;
  final int? sliderItemCount;
  final BoxShape? boxShape;
  final Color? color;

  const DazzifyLoadingShimmer({
    super.key,
    this.borderRadius,
    this.cardWidth,
    this.cardHeight,
    this.crossAxisCount,
    this.mainAxisExtent,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.widgetPadding,
    this.children,
    this.scrollDirection,
    this.gridViewItemCount,
    this.listViewItemCount,
    required this.dazzifyLoadingType,
    this.sliderItemCount,
    this.itemPadding,
    this.separatorHeight,
    this.separatorWidth,
    this.boxShape,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.isDarkTheme
          ? ColorsManager.baseShimmerDark
          : ColorsManager.baseShimmerLight,
      highlightColor: context.isDarkTheme
          ? ColorsManager.highlightShimmerDark
          : ColorsManager.highlightShimmerLight,
      period: const Duration(milliseconds: 1000),
      child: CustomFadeAnimation(
        duration: const Duration(milliseconds: 200),
        child: buildDazzifyShimmerLoading(context),
      ),
    );
  }

  Widget buildDazzifyShimmerLoading(BuildContext context) {
    switch (dazzifyLoadingType) {
      case DazzifyLoadingType.custom:
        return customizableShimmer(context);
      case DazzifyLoadingType.listView:
        return buildListViewShimmer();
      case DazzifyLoadingType.gridView:
        return buildGridViewShimmer();
      case DazzifyLoadingType.slider:
        return sliderShimmer();
      case DazzifyLoadingType.messages:
        return buildMessagesShimmer(context);
      case DazzifyLoadingType.brands:
        return buildBrandsShimmer();
    }
  }

  Widget buildGridViewShimmer() {
    return GridView.builder(
      padding: widgetPadding ?? const EdgeInsets.symmetric(horizontal: 16.0).r,
      scrollDirection: scrollDirection ?? Axis.vertical,
      itemCount: gridViewItemCount ?? 15,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount ?? 3,
        mainAxisExtent: mainAxisExtent ?? 150.h,
        crossAxisSpacing: crossAxisSpacing ?? 10.w,
        mainAxisSpacing: mainAxisSpacing ?? 10.h,
      ),
      itemBuilder: (context, index) => customizableShimmer(context),
    );
  }

  Widget buildListViewShimmer() {
    return ListView.separated(
      padding: widgetPadding ?? const EdgeInsets.symmetric(horizontal: 16.0).r,
      scrollDirection: scrollDirection ?? Axis.vertical,
      itemCount: listViewItemCount ?? 5,
      itemBuilder: (context, index) => customizableShimmer(context),
      separatorBuilder: (context, index) => SizedBox(
        height: separatorHeight ?? 8.h,
        width: separatorWidth ?? 8.w,
      ),
    );
  }

  Widget buildMessagesShimmer(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8).r,
      itemCount: 20,
      reverse: true,
      itemBuilder: (context, index) {
        if (index % 2 == 0) {
          return Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              height: separatorHeight ?? 50.h,
              width: separatorWidth ?? getRandomDouble(100, 180).w,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: const Radius.circular(20).r,
                  topEnd: const Radius.circular(20).r,
                  bottomStart: const Radius.circular(20).r,
                  bottomEnd: Radius.zero,
                ),
              ),
            ),
          );
        } else {
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: separatorHeight ?? 50.h,
              width: separatorWidth ?? getRandomDouble(100, 160).w,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadiusDirectional.only(
                    topStart: const Radius.circular(20).r,
                    topEnd: const Radius.circular(20).r,
                    bottomEnd: const Radius.circular(20).r,
                    bottomStart: Radius.zero),
              ),
            ),
          );
        }
      },
    );
  }

  Widget sliderShimmer() {
    return Padding(
      padding: widgetPadding ?? const EdgeInsets.symmetric(horizontal: 8.0).r,
      child: CarouselSlider.builder(
        itemCount: sliderItemCount ?? 5,
        itemBuilder: (context, index, realIndex) {
          return customizableShimmer(context);
        },
        options: CarouselOptions(
          height: 200.h,
          viewportFraction: 0.4,
          autoPlay: false,
          autoPlayCurve: Curves.ease,
          enlargeCenterPage: true,
          disableCenter: true,
          enlargeFactor: 0.27,
          initialPage: 0,
        ),
      ),
    );
  }

  Widget buildBrandsShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.only(
        top: 28,
        left: 16,
        right: 16,
      ).r,
      itemCount: 10,
      separatorBuilder: (context, index) => SizedBox(height: 36.h),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: context.isDarkTheme
                  ? ColorsManager.baseShimmerDark
                  : ColorsManager.baseShimmerLight,
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loadingContainer(context, 80.w),
                SizedBox(height: 10.h),
                loadingContainer(context, 200.w),
                SizedBox(height: 5.h),
                loadingContainer(context, 200.w),
                SizedBox(height: 12.h),
                loadingContainer(context, 120.w),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loadingContainer(context, 40.w),
                SizedBox(height: 8.h),
                loadingContainer(context, 40.w),
                SizedBox(width: 12.w),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget loadingContainer(BuildContext context, double width) {
    return Container(
      height: 10.h,
      width: width,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(4).r,
      ),
    );
  }

  Widget customizableShimmer(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10).r,
      child: Container(
        width: cardWidth ?? 100.w,
        height: cardHeight ?? 100.h,
        decoration: BoxDecoration(
          color: color ?? context.colorScheme.primary,
          shape: boxShape ?? BoxShape.rectangle,
        ),
        child: children,
      ),
    );
  }

  double getRandomDouble(double min, double max) {
    Random random = Random();
    return min + (random.nextDouble() * (max - min));
  }
}

enum DazzifyLoadingType {
  custom,
  gridView,
  listView,
  slider,
  messages,
  brands,
}

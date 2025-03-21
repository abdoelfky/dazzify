import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar(
      {super.key, required this.onRatingUpdate, required this.initialRating});

  final ValueChanged<double> onRatingUpdate;
  final double initialRating;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 5,
      allowHalfRating: true,
      glowColor: context.colorScheme.outline,
      itemSize: 35.r,
      itemPadding: const EdgeInsets.symmetric(horizontal: 12.0).r,
      ratingWidget: RatingWidget(
        full: const Icon(
          Icons.star,
          color: ColorsManager.starsColor,
        ),
        half: const Icon(
          Icons.star_half,
          color: ColorsManager.starsColor,
        ),
        empty: Icon(
          Icons.star_border,
          color: context.colorScheme.outline,
        ),
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}

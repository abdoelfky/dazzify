import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_rounded_picture.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatelessWidget {
  final String reviewerImage;
  final String reviewerName;
  final String reviewDescription;
  final double reviewRating;
  final bool isLate;
  final int index;

  const ReviewCard({
    super.key,
    required this.reviewerImage,
    required this.reviewerName,
    required this.reviewRating,
    required this.reviewDescription,
    required this.isLate,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFadeAnimation(
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 328.w,
        constraints: BoxConstraints(minHeight: 180.h),
        decoration: BoxDecoration(
          color: context.colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(20).r,
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 40.r,
                    height: 40.r,
                    child: DazzifyRoundedPicture(
                      imageUrl: reviewerImage,
                      height: 40.r,
                      width: 40.r,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    width: 100.w,
                    child: DText(reviewerName,
                        maxLines: 2,
                        style: context.textTheme.bodyMedium),
                  ),
                  const Spacer(flex: 3),
                  Row(
                    children: [
                      Icon(
                        isLate
                            ? SolarIconsOutline.dangerCircle
                            : SolarIconsOutline.checkCircle,
                        color: isLate
                            ? context.colorScheme.error
                            : ColorsManager.successColor,
                        size: 16.r,
                      ),
                      SizedBox(width: 3.w),
                      DText(
                        isLate
                            ? context.tr.arrivedLate
                            : context.tr.arrivedAtTime,
                        style: context.textTheme.labelSmall!.copyWith(
                          color: isLate
                              ? context.colorScheme.error
                              : ColorsManager.successColor,
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 7.h),
              RatingBarIndicator(
                unratedColor: context.colorScheme.outline,
                itemSize: 10.r,
                itemPadding: const EdgeInsets.all(4).r,
                rating: reviewRating,
                itemBuilder: (context, index) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    key: ValueKey<double>(reviewRating),
                    Icons.star,
                    color: ColorsManager.starsColor,
                    size: 22.r,
                  ),
                ),
              ),
              SizedBox(height: reviewDescription.isEmpty ? 30.h : 12.h),
              Align(
                alignment: Alignment.topLeft,
                child: DText(
                  reviewDescription,
                  style: context.textTheme.bodySmall,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/home/logic/service_details/service_details_bloc.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/review_card.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RatingAndReviewsComponent extends StatefulWidget {
  final ServiceDetailsModel service;

  const RatingAndReviewsComponent({super.key, required this.service});

  @override
  State<RatingAndReviewsComponent> createState() =>
      _RatingAndReviewsComponentState();
}

class _RatingAndReviewsComponentState extends State<RatingAndReviewsComponent> {
  late final ServiceDetailsBloc serviceDetailsBloc;

  @override
  void initState() {
    super.initState();
    serviceDetailsBloc = context.read<ServiceDetailsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DText(
                  context.tr.ratingAndReviewsTitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                DText(
                  context.tr.ratingAndReviewsSubTitle,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Center(
            child: DText(
              widget.service.rating.toString(),
              style: context.textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 5.h),
          ratingSection(context, widget.service),
          serviceReviewSection(
            widget.service.id,
            serviceDetailsBloc,
          ),
        ],
      ),
    );
  }
}

Widget ratingSection(BuildContext context, ServiceDetailsModel service) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: List.generate(5, (index) {
      final String starRating = "${5 - index}";
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0).r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DText(
              starRating,
              style: context.textTheme.bodyLarge,
            ),
            SizedBox(width: 4.r),
            Icon(
              Icons.star,
              color: ColorsManager.starsColor,
              size: 24.r,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: LinearPercentIndicator(
                width: 220.w,
                lineHeight: 8.h,
                curve: Curves.bounceInOut,
                backgroundColor: context.colorScheme.onPrimary,
                progressColor: context.colorScheme.primary,
                barRadius: const Radius.circular(5).r,
                percent: service.ratingPercentage[starRating] ?? 0.0,
              ),
            )
          ],
        ),
      );
    }),
  );
}

Widget serviceReviewSection(
  String serviceId,
  ServiceDetailsBloc serviceDetailsBloc,
) {
  return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
    builder: (context, state) {
      switch (state.serviceReviewState) {
        case UiState.initial:
        case UiState.loading:
          return SizedBox(
            height: 180.h,
            child: DazzifyLoadingShimmer(
              dazzifyLoadingType: DazzifyLoadingType.listView,
              listViewItemCount: 2,
              cardWidth: 328.w,
              cardHeight: 180.h,
            ),
          );
        case UiState.failure:
          return DText(state.errorMessage);
        case UiState.success:
          if (state.serviceReview.isEmpty) {
            return const SizedBox.shrink();
          } else {
            return Column(
              children: [
                ListView.builder(
                  itemCount: state.serviceReview.length > 3
                      ? 3
                      : state.serviceReview.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 24,
                    right: 24,
                  ).r,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final review = state.serviceReview[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0).r,
                      child: ReviewCard(
                        reviewerImage: review.user.profileImage,
                        reviewerName: review.user.fullName,
                        reviewRating: review.rate,
                        reviewDescription: review.comment,
                        isLate: review.isLate,
                        index: index,
                      ),
                    );
                  },
                ),
                if (state.serviceReviewState == UiState.success &&
                    state.serviceReview.length > 3)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.pushRoute(
                          SeeAllReviewsRoute(
                            serviceId: serviceId,
                            serviceDetailsBloc: serviceDetailsBloc,
                          ),
                        );
                      },
                      child: DText(
                        context.tr.seeAllReviews,
                        style: context.textTheme.labelMedium!.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  )
              ],
            );
          }
      }
    },
  );
}

import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandReviewsTab extends StatefulWidget {
  final String brandId;
  final TabController tabController;
  final ScrollController scrollController;

  const BrandReviewsTab({
    super.key,
    required this.brandId,
    required this.tabController,
    required this.scrollController,
  });

  @override
  State<BrandReviewsTab> createState() => _BrandReviewsTabState();
}

class _BrandReviewsTabState extends State<BrandReviewsTab>
    with AutomaticKeepAliveClientMixin {
  late final BrandBloc brandBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    brandBloc = context.read<BrandBloc>();
    brandBloc.add(GetBrandReviewsEvent(widget.brandId));
    widget.scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (widget.tabController.index == 2) {
      final maxScroll = widget.scrollController.position.maxScrollExtent;
      final currentScroll = widget.scrollController.offset;
      if (currentScroll >= (maxScroll * 0.8)) {
        brandBloc.add(GetBrandReviewsEvent(widget.brandId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        switch (state.reviewsState) {
          case UiState.initial:
          case UiState.loading:
            return DazzifyLoadingShimmer(
              dazzifyLoadingType: DazzifyLoadingType.listView,
              widgetPadding:
                  const EdgeInsets.only(top: 16.0, left: 24, right: 24).r,
              cardWidth: 328.w,
              cardHeight: 180.h,
            );
          case UiState.failure:
            return ErrorDataWidget(
              errorDataType: DazzifyErrorDataType.screen,
              message: state.errorMessage,
              onTap: () {
                brandBloc.add(GetBrandReviewsEvent(widget.brandId));
              },
            );
          case UiState.success:
            if (state.reviews.isEmpty) {
              return CustomFadeAnimation(
                duration: const Duration(milliseconds: 300),
                child: EmptyDataWidget(
                  message: context.tr.noReviews,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: state.reviews.length,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.only(top: 16.0, left: 24, right: 24).r,
                itemBuilder: (context, index) {
                  if (index >= state.reviews.length &&
                      state.reviews.isNotEmpty) {
                    if (state.hasReviewsReachedMax) {
                      return const SizedBox.shrink();
                    } else {
                      return SizedBox(
                        height: 70.h,
                        width: context.screenWidth,
                        child: LoadingAnimation(
                          height: 50.h,
                          width: 50.w,
                        ),
                      );
                    }
                  } else {
                    final review = state.reviews[index];
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
                  }
                },
              );
            }
        }
      },
    );
  }
}

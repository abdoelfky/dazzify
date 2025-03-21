import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/service_details/service_details_bloc.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SeeAllReviewsScreen extends StatefulWidget implements AutoRouteWrapper {
  final String serviceId;
  final ServiceDetailsBloc serviceDetailsBloc;

  const SeeAllReviewsScreen({
    super.key,
    required this.serviceId,
    required this.serviceDetailsBloc,
  });

  @override
  State<SeeAllReviewsScreen> createState() => _SeeAllReviewsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(
      value: serviceDetailsBloc,
      child: this,
    );
  }
}

class _SeeAllReviewsScreenState extends State<SeeAllReviewsScreen> {
  late final ServiceDetailsBloc serviceDetailsBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    serviceDetailsBloc = context.read<ServiceDetailsBloc>();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      serviceDetailsBloc.add(
        GetServiceReviewsEvent(serviceId: widget.serviceId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DazzifyAppBar(
              isLeading: true,
              title: context.tr.allReviews,
            ),
            BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.serviceReview.length,
                    itemBuilder: (context, index) {
                      if (index >= state.serviceReview.length &&
                          state.serviceReview.isNotEmpty) {
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
                        final service = state.serviceReview[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            right: 8.0,
                            left: 8.0,
                          ).r,
                          child: ReviewCard(
                            reviewerImage: service.user.profileImage,
                            reviewerName: service.user.fullName,
                            reviewRating: service.rate,
                            reviewDescription: service.comment,
                            isLate: service.isLate,
                            index: index,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}

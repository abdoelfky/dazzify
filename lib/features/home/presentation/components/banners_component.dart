import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/brand/logic/booking_from_media/booking_from_media_cubit.dart';
import 'package:dazzify/features/home/helper/banner_helper.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/shared/enums/banners_action_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/rectangular_animated_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannersComponent extends StatefulWidget {
  const BannersComponent({super.key});

  @override
  State<BannersComponent> createState() => _BannersComponentState();
}

class _BannersComponentState extends State<BannersComponent> {
  late final ValueNotifier<int> currentBannerIndex;
  late BannersAction bannersAction;
  late final BookingFromMediaCubit bookingFromMediaCubit;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    currentBannerIndex = ValueNotifier(0);
    bookingFromMediaCubit = getIt<BookingFromMediaCubit>();
    super.initState();
  }

  @override
  void dispose() {
    currentBannerIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        switch (state.bannersState) {
          case UiState.initial:
          case UiState.loading:
            return DazzifyLoadingShimmer(
              borderRadius: BorderRadius.zero,
              dazzifyLoadingType: DazzifyLoadingType.custom,
              cardWidth: context.screenWidth,
              cardHeight: 320.h,
            );
          case UiState.failure:
            return SizedBox(
              width: context.screenWidth,
              height: 290.h,
            );
          case UiState.success:
            return SizedBox(
              width: context.screenWidth,
              height: 290.h,
              child: Stack(
                children: [
                  state.banners.isEmpty
                      ? Center(
                          child: EmptyDataWidget(
                            message: context.tr.noData,
                          ),
                        )
                      : CarouselSlider.builder(
                          itemCount: state.banners.length,
                          itemBuilder: (context, index, realIndex) {
                            bannersAction =
                                getBannersAction(state.banners[index].action);
                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _logger.logEvent(
                                      event: AppEvents.homeClickBanner,
                                      bannerId: state.banners[index].id,
                                    );
                                    if (AuthLocalDatasourceImpl()
                                        .checkGuestMode()) {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: false,
                                        builder: (context) {
                                          return GuestModeBottomSheet();
                                        },
                                      );
                                    } else {
                                      BannerHelper.onBannerTap(
                                        context: context,
                                        homeState: state,
                                        bookingState: bookingFromMediaCubit.state,
                                        bannersAction: bannersAction,
                                        index: index,
                                      );
                                    }
                                  },
                                  child: DazzifyCachedNetworkImage(

                                    width: context.screenWidth,
                                    height: 320.h,
                                    imageUrl: state.banners[index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Text overlay in top-left
                                PositionedDirectional(
                                  start: 20.w,
                                  top: 20.h,
                                  child: IgnorePointer(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (state.banners[index].mainCategory != null)
                                          DText(
                                            state.banners[index].mainCategory!.name,
                                            style: context.textTheme.headlineMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28.sp,
                                            ),
                                          ),
                                        if (state.banners[index].coupon != null)
                                          Padding(
                                            padding: EdgeInsets.only(top: 4.h),
                                            child: DText(
                                              '${state.banners[index].coupon}% OFF',
                                              style: context.textTheme.titleLarge?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          options: CarouselOptions(
                            height: 320.h,
                            viewportFraction: 1,
                            autoPlay: state.banners.length > 1,
                            autoPlayCurve: Curves.ease,
                            enlargeCenterPage: false,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            scrollPhysics: const BouncingScrollPhysics(),
                            onPageChanged: (index, reason) {
                              currentBannerIndex.value = index;
                            },
                          ),
                        ),
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    bottom: 70.h,
                    child: Visibility(
                      visible: state.banners.length > 1,
                      child: ValueListenableBuilder<int>(
                        valueListenable: currentBannerIndex,
                        builder: (context, activeIndex, child) {
                          return RectangularAnimatedIndicator(
                            dotWidth: 30.w,
                            dotHeight: 4.h,
                            currentIndex: activeIndex,
                            selectedColor: ColorsManager.activeIndicatorColor,
                            unSelectedColor:
                                ColorsManager.inActiveIndicatorColor,
                            axisDirection: Axis.horizontal,
                            dotsCount: state.banners.length,
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }
}

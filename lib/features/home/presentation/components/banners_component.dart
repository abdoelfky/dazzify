import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzify/core/injection/injection.dart';
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
import 'package:dazzify/features/shared/widgets/glass_icon_button.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/rectangular_animated_indicator.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class BannersComponent extends StatefulWidget {
  const BannersComponent({super.key});

  @override
  State<BannersComponent> createState() => _BannersComponentState();
}

class _BannersComponentState extends State<BannersComponent> {
  late final ValueNotifier<int> currentBannerIndex;
  late BannersAction bannersAction;
  late final BookingFromMediaCubit bookingFromMediaCubit;

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
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ).r,
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
              height: 320.h,
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
                            return ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ).r,
                              child: GestureDetector(
                                onTap: () => BannerHelper.onBannerTap(
                                  context: context,
                                  homeState: state,
                                  bookingState: bookingFromMediaCubit.state,
                                  bannersAction: bannersAction,
                                  index: index,
                                ),
                                child: DazzifyCachedNetworkImage(
                                  width: context.screenWidth,
                                  height: 320.h,
                                  imageUrl: state.banners[index].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 320.h,
                            viewportFraction: 1,
                            autoPlay: state.banners.length > 1,
                            autoPlayCurve: Curves.ease,
                            enlargeCenterPage: false,
                            initialPage: 0,
                            onPageChanged: (index, reason) {
                              currentBannerIndex.value = index;
                            },
                          ),
                        ),
                  PositionedDirectional(
                    end: 30.w,
                    top: 40.h,
                    child: GlassIconButton(
                      icon: SolarIconsOutline.heart,
                      onPressed: () {
                        context.navigateTo(const MyFavoriteRoute());
                      },
                    ),
                  ),
                  PositionedDirectional(
                    start: 30.w,
                    top: 40.h,
                    child: GlassIconButton(
                      icon: SolarIconsOutline.bell,
                      onPressed: () {
                        if (AuthLocalDatasourceImpl().checkGuestMode()) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: false,
                            builder: (context) {
                              return GuestModeBottomSheet();
                            },
                          );
                        }else {
                          context.pushRoute(const NotificationsRoute());
                        }
                      },
                    ),
                  ),
                  PositionedDirectional(
                    start: 10.w,
                    bottom: 25.h,
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

import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/presentation/components/banners_component.dart';
import 'package:dazzify/features/home/presentation/components/categories_component.dart';
import 'package:dazzify/features/home/presentation/components/home_app_bar_component.dart';
import 'package:dazzify/features/home/presentation/components/last_active_booking_component.dart';
import 'package:dazzify/features/home/presentation/components/popular_brands_component.dart';
import 'package:dazzify/features/home/presentation/components/popular_service_component.dart';
import 'package:dazzify/features/home/presentation/components/top_rated_brands_component.dart';
import 'package:dazzify/features/home/presentation/components/top_rated_services_component.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late final HomeCubit homeCubit;
  late final UserCubit userCubit;
  late final BookingCubit bookingCubit;
  bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    homeCubit = context.read<HomeCubit>();
    userCubit = context.read<UserCubit>();
    bookingCubit = context.read<BookingCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusBarColor = context.colorScheme.primary.withOpacity(.2);

    return SafeArea(
      top: false,
      bottom: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
        ),
        child: Stack(
          children: [
            Scaffold(
              extendBody: true,
              body: RefreshIndicator(
                onRefresh: () async {
                  mainCategories.clear();
                  await Future.wait([
                    bookingCubit.getLastActiveBookings(),
                    homeCubit.getBanners(),
                    homeCubit.getMainCategories(),
                    homeCubit.getPopularBrands(),
                    homeCubit.getTopRatedBrands(),
                    homeCubit.getPopularServices(),
                    homeCubit.getTopRatedServices(),
                  ]);
                },
                color: context.colorScheme.primary,
                backgroundColor: context.colorScheme.surface,
                child: BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    homeCubitListener(state, context);
                  },
                  builder: (context, state) {
                    if (state.bannersState == UiState.failure ||
                        state.categoriesState == UiState.failure ||
                        state.popularBrandsState == UiState.failure ||
                        state.topRatedBrandsState == UiState.failure ||
                        state.popularServicesState == UiState.failure ||
                        state.topRatedServicesState == UiState.failure ||
                        bookingCubit.state.lastActiveBookingState ==
                            UiState.failure) {
                      return ErrorDataWidget(
                        errorDataType: DazzifyErrorDataType.screen,
                        message: state.errorMessage,
                        onTap: () {
                          homeCubit
                            ..getBanners()
                            ..getMainCategories()
                            ..getPopularBrands()
                            ..getTopRatedBrands()
                            ..getPopularServices()
                            ..getTopRatedServices()
                            ..getPopularServices();

                          bookingCubit.getLastActiveBookings();
                          userCubit.getUser();
                        },
                      );
                    } else {
                      return DazzifyOverlayLoading(
                          isLoading: isLoading,
                          child: SingleChildScrollView(
                            // physics: const ScrollPhysics(),
                            child: Column(children:
                                    // [
                                    [
                              // App Bar on to
                              const HomeAppBarComponent(),
                              SizedBox(height: 12.r),
                              // Banner with negative margin to show above App Bar
                              const BannersComponent(),

                              Positioned(
                                top: 350.h,
                                left: 0,
                                right: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                  ).r,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context.colorScheme.surface,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                      ).r,
                                    ),
                                    child: Column(
                                      children: [
                                        const CategoriesComponent(),
                                        const LastActiveBookingComponent(),
                                        const PopularBrandsComponent(),
                                        const TopRatedBrandsComponent(),
                                        // const PopularServiceComponent(),
                                        const TopServicesComponent(),
                                        // SizedBox(height: 70.h),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]
                                // Stack(
                                //   clipBehavior: Clip.none,
                                //   children: [
                                //     SizedBox(
                                //       height: 1310.h,
                                //     ),
                                //     // Banner with negative margin to show above App Bar
                                //     Positioned(
                                //       top: 131.h,
                                //       left: 0,
                                //       right: 0,
                                //       child: const BannersComponent(),
                                //     ),
                                //     // App Bar on to
                                //     const HomeAppBarComponent(),
                                //
                                //     Positioned(
                                //       top: 350.h,
                                //       left: 0,
                                //       right: 0,
                                //       child: ClipRRect(
                                //         borderRadius: const BorderRadius.only(
                                //           topLeft: Radius.circular(40),
                                //         ).r,
                                //         child: Container(
                                //           decoration: BoxDecoration(
                                //             color: context.colorScheme.surface,
                                //             borderRadius:
                                //                 const BorderRadius.only(
                                //               topLeft: Radius.circular(20),
                                //             ).r,
                                //           ),
                                //           child: Column(
                                //             children: [
                                //               const CategoriesComponent(),
                                //               const LastActiveBookingComponent(),
                                //               const PopularBrandsComponent(),
                                //               const TopRatedBrandsComponent(),
                                //               const PopularServiceComponent(),
                                //               const TopServicesComponent(),
                                //               // SizedBox(height: 70.h),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     )
                                //   ],
                                // ),

                                // SliverList(
                                //   delegate: SliverChildListDelegate([
                                //     // Bottom padding
                                //   ]),
                                // ),
                                // ],
                                ),
                          ));
                    }
                  },
                ),
              ),
            ),
            // Status bar overlay (drawn on top so it's not covered)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: MediaQuery.of(context).padding.top,
                  color: statusBarColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void homeCubitListener(
    HomeState state,
    BuildContext context,
  ) {
    switch (state.singleServiceState) {
      case UiState.initial:
        isLoading = false;
      case UiState.loading:
        isLoading = true;
      case UiState.success:
        if (isLoading) {
          context.pushRoute(ServiceDetailsRoute(service: state.singleService));
          isLoading = false;
        }
      case UiState.failure:
        DazzifyToastBar.showError(
          message: state.errorMessage,
        );
        isLoading = false;
    }
  }
}

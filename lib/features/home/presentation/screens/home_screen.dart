import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/presentation/components/banners_component.dart';
import 'package:dazzify/features/home/presentation/components/categories_component.dart';
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
    return Scaffold(
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
                bookingCubit.state.lastActiveBookingState == UiState.failure) {
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
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 70).r,
                  children: const [
                    BannersComponent(),
                    CategoriesComponent(),
                    LastActiveBookingComponent(),
                    PopularBrandsComponent(),
                    TopRatedBrandsComponent(),
                    PopularServiceComponent(),
                    TopServicesComponent(),
                  ],
                ),
              );
            }
          },
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

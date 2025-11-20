import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/multiple_service_availability_cubit/multiple_service_availability_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/date_selection_widget/multiple_service_date_selection_widget.dart';
import 'package:dazzify/features/booking/presentation/widgets/proceed_button/multiple_booking_proceed_button.dart';
import 'package:dazzify/features/booking/presentation/widgets/selection_confirmation/multiple_booking_selection_confirmation.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/multiple_booking_time_selection_widget.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/brand/logic/service_selection/service_selection_cubit.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class MultipleServiceAvailabilityScreen extends StatefulWidget
    implements AutoRouteWrapper {
  final List<ServiceDetailsModel> services;
  final String branchId;
  final String branchName;
  final LocationModel? location;
  final String brandId;
  final ServiceSelectionCubit? serviceSelectionCubit;

  const MultipleServiceAvailabilityScreen({
    required this.services,
    required this.branchId,
    required this.branchName,
    this.location,
    this.serviceSelectionCubit,
    super.key,
    required this.brandId,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MultipleServiceAvailabilityCubit>()
        ..getAndProcessData(
          services: services.map((service) => service.id).toList(),
          branchId: branchId,
        ),
      child: this,
    );
  }

  @override
  State<MultipleServiceAvailabilityScreen> createState() =>
      _MultipleServiceAvailabilityScreenState();
}

class _MultipleServiceAvailabilityScreenState
    extends State<MultipleServiceAvailabilityScreen> {
  bool isShimmeringDateSelection = true;
  late final List<String> servicesIds =
      widget.services.map((service) => service.id).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: DazzifyAppBar(
              isLeading: true,
              title: widget.branchName,
            ),
          ),
          BlocConsumer<MultipleServiceAvailabilityCubit,
              MultipleServiceAvailabilityState>(
            listener: (context, state) {
              if (state.blocState == UiState.success) {
                isShimmeringDateSelection = false;
              }
            },
            builder: (context, state) {
              switch (state.blocState) {
                case UiState.initial:
                case UiState.loading:
                  return Column(
                    children: [
                      isShimmeringDateSelection
                          ? dateSelectionShimmering()
                          : MultipleServiceDateSelectionWidget(
                              services: servicesIds,
                              branchId: widget.branchId,
                            ),
                      timeSelectionAndButtonShimmering()
                    ],
                  );

                case UiState.success:
                  return successAvailabilityBody(state, context);
                case UiState.failure:
                  return ErrorDataWidget(
                    onTap: () {
                      context
                          .read<MultipleServiceAvailabilityCubit>()
                          .getAndProcessData(
                            branchId: widget.branchId,
                            services: servicesIds,
                          );
                    },
                    errorDataType: DazzifyErrorDataType.screen,
                    message: state.errorMessage,
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Column successAvailabilityBody(
    MultipleServiceAvailabilityState state,
    BuildContext context,
  ) {
    return Column(
      children: [
        MultipleServiceDateSelectionWidget(
          services: servicesIds,
          branchId: widget.branchId,
        ),
        SizedBox(height: 10.h),
        state.availableSessions.isEmpty
            ? SizedBox(
                height: context.screenHeight * 0.4,
                width: context.screenWidth,
                child: EmptyDataWidget(
                  message: context.tr.noSessionsToday,
                ),
              )
            : Column(
                children: [
                  const MultipleBookingTimeSelectionWidget(),
                  SizedBox(
                    height: 16.h,
                  ),
                  if (!state.isAnySessionSelected) SizedBox(height: 36.h),
                  if (state.isAnySessionSelected)
                    const MultipleBookingSelectionConfirmation(),
                  SizedBox(
                    height: 16.h,
                  ),
                  MultipleBookingProceedButton(
                    services: widget.services,
                    serviceSelectionCubit: widget.serviceSelectionCubit,
                    branchId: widget.branchId,
                    branchName: widget.branchName,
                    location: widget.location,
                  ),
                  SizedBox(height: 90.h)
                ],
              ),
      ],
    );
  }
}

DazzifyLoadingShimmer dateSelectionShimmering() {
  return DazzifyLoadingShimmer(
    dazzifyLoadingType: DazzifyLoadingType.custom,
    cardWidth: 328.w,
    cardHeight: 338.h,
    borderRadius: BorderRadius.circular(16).r,
  );
}

Column timeSelectionAndButtonShimmering() {
  return Column(
    children: [
      SizedBox(
        height: 8.h,
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    //digital clock
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //from time
                        DazzifyLoadingShimmer(
                          dazzifyLoadingType: DazzifyLoadingType.custom,
                          cardWidth: 64.w,
                          cardHeight: 54.h,
                          borderRadius: BorderRadius.all(
                            const Radius.circular(5.5).r,
                          ),
                        ),
                        //two dots
                        SizedBox(
                          width: 22.w,
                        ),
                        //to clock
                        DazzifyLoadingShimmer(
                          dazzifyLoadingType: DazzifyLoadingType.custom,
                          cardWidth: 64.w,
                          cardHeight: 54.h,
                          borderRadius: BorderRadius.all(
                            const Radius.circular(5.5).r,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // dayime buttons
                    DazzifyLoadingShimmer(
                      dazzifyLoadingType: DazzifyLoadingType.custom,
                      cardWidth: 150.w,
                      cardHeight: 26.h,
                      borderRadius: BorderRadius.all(
                        const Radius.circular(5.5).r,
                      ),
                    ),
                  ],
                ),
                //analog clock
                DazzifyLoadingShimmer(
                  dazzifyLoadingType: DazzifyLoadingType.custom,
                  boxShape: BoxShape.circle,
                  cardWidth: 150.w,
                  cardHeight: 150.w,
                  borderRadius: BorderRadius.all(
                    const Radius.circular(5.5).r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        height: 88.h,
      ),
      DazzifyLoadingShimmer(
        dazzifyLoadingType: DazzifyLoadingType.custom,
        cardWidth: 312.w,
        cardHeight: 42.h,
        borderRadius: BorderRadius.all(
          const Radius.circular(5.5).r,
        ),
      ),
      SizedBox(
        height: 90.h,
      ),
    ],
  );
}

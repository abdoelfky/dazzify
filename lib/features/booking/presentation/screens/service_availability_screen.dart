import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/service_availability_cubit/service_availability_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/date_selection_widget/date_selection_widget.dart';
import 'package:dazzify/features/booking/presentation/widgets/proceed_button/proceed_button.dart';
import 'package:dazzify/features/booking/presentation/widgets/selection_confirmation/selection_confirmation.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/time_selection_widget.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ServiceAvailabilityScreen extends StatefulWidget
    implements AutoRouteWrapper {
  final ServiceDetailsModel service;
  final String branchId;
  final String branchName;
  final LocationModel? location;

  const ServiceAvailabilityScreen({
    required this.service,
    required this.branchId,
    required this.branchName,
    this.location,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ServiceAvailabilityCubit>(
      create: (context) => getIt<ServiceAvailabilityCubit>()
        ..getAndProcessData(
          serviceId: service.id,
          branchId: branchId,
        ),
      child: this,
    );
  }

  @override
  State<ServiceAvailabilityScreen> createState() =>
      _ServiceAvailabilityScreenState();
}

class _ServiceAvailabilityScreenState extends State<ServiceAvailabilityScreen> {
  bool isShimmeringDateSelection = true;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          _logger.logEvent(event: AppEvents.calendarClickBack);
        }
      },
      child: Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(),
          children: [
            DazzifyAppBar(
              isLeading: true,
              title: widget.branchName,
              onBackTap: () {
                _logger.logEvent(event: AppEvents.calendarClickBack);
                context.maybePop();
              },
            ),
            BlocConsumer<ServiceAvailabilityCubit, ServiceAvailabilityState>(
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
                            : DateSelectionWidget(
                                serviceId: widget.service.id,
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
                            .read<ServiceAvailabilityCubit>()
                            .getAndProcessData(
                              branchId: widget.branchId,
                              serviceId: widget.service.id,
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
      ),
      ),
    );
  }

  Column successAvailabilityBody(
    ServiceAvailabilityState state,
    BuildContext context,
  ) {
    return Column(
      children: [
        DateSelectionWidget(
          serviceId: widget.service.id,
          branchId: widget.branchId,
        ),
        SizedBox(height: 8.h),
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
                  const TimeSelectionWidget(),
                  SizedBox(
                    height: 16.h,
                  ),
                  if (!state.isAnySessionSelected) SizedBox(height: 36.h),
                  if (state.isAnySessionSelected) const SelectionConfirmation(),
                  SizedBox(
                    height: 16.h,
                  ),
                  ProceedButton(
                    service: widget.service,
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
                    SizedBox(
                      height: 8.h,
                    ),
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

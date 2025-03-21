import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/multiple_service_availability_cubit/multiple_service_availability_cubit.dart';
import 'package:dazzify/features/booking/presentation/bottom_sheets/brand_terms_sheet.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultipleBookingProceedButton extends StatelessWidget {
  final List<ServiceDetailsModel> services;
  final String branchId;
  final String branchName;
  final LocationModel? location;

  const MultipleBookingProceedButton({
    required this.services,
    required this.branchId,
    required this.branchName,
    this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultipleServiceAvailabilityCubit,
        MultipleServiceAvailabilityState>(
      builder: (context, state) {
        return PrimaryButton(
            isActive: state.isSessionConfirmed,
            width: 328.w,
            height: 42.h,
            onTap: () async {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                routeSettings: const RouteSettings(name: "brandTermsSheet"),
                builder: (context) {
                  return BrandTermsSheet(
                    service: services.first,
                    branchId: branchId,
                    branchName: branchName,
                    branchLocation: location,
                    selectedDate: state.selectedDate,
                    selectedStartTimeStamp:
                        state.selectedSession.startTimeStamp,
                    selectedFromTime: state.selectedSession.fromTime,
                    selectedToTime: state.selectedSession.toTime,
                  );
                },
              );
            },
            title: context.tr.proceed);
      },
    );
  }
}

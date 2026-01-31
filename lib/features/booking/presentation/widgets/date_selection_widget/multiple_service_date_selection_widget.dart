import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart' show getIt;
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/multiple_service_availability_cubit/multiple_service_availability_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MultipleServiceDateSelectionWidget extends StatelessWidget {
  final List<String> services;
  final String branchId;

  const MultipleServiceDateSelectionWidget({
    required this.services,
    required this.branchId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppEventsLogger _logger = getIt<AppEventsLogger>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16).r,
      width: 328.w,
      height: 338.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          const Radius.circular(16).r,
        ),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorsManager.timeGradiant1,
            ColorsManager.timeGradiant2,
            ColorsManager.timeGradiant3,
          ],
        ),
      ),
      child: SfDateRangePicker(
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          _logger.logEvent(event: AppEvents.calendarSelectDate);

          context.read<MultipleServiceAvailabilityCubit>().changeSelectedDate(
                services: services,
                branchId: branchId,
                newDate: args.value.toString(),
              );
        },
        enablePastDates: false,
        backgroundColor: Colors.transparent,
        headerStyle: DateRangePickerHeaderStyle(
          backgroundColor: Colors.transparent,
          textAlign: TextAlign.center,
          textStyle: context.textTheme.labelSmall!
              .copyWith(color: context.colorScheme.onSurface),
        ),
        showNavigationArrow: true,
        monthViewSettings: const DateRangePickerMonthViewSettings(
          firstDayOfWeek: 6,
          showTrailingAndLeadingDates: true,
          dayFormat: AppConstants.calenderDayFormat,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          textStyle: context.textTheme.labelMedium!
              .copyWith(color: context.colorScheme.onSurface),
          blackoutDatesDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.primaryContainer.withValues(alpha: 0.2),
          ),
          blackoutDateTextStyle: context.textTheme.labelMedium!.copyWith(
            color:
                context.colorScheme.onPrimaryContainer.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}

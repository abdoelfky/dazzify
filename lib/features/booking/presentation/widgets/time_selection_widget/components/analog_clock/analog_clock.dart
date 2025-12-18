import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/features/booking/logic/service_availability_cubit/service_availability_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/build_vendor_sessions_stack.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/clock_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalogClock extends StatelessWidget {
  final double diameter;

  const AnalogClock({
    required this.diameter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceAvailabilityCubit, ServiceAvailabilityState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            getIt<AppEventsLogger>()
                .logEvent(event: AppEvents.calendarSelectTime);
            context.read<ServiceAvailabilityCubit>().changeSelectedSession();
          },
          child: SizedBox(
            width: diameter,
            height: diameter,
            child: Stack(
              children: [
                Container(
                  width: diameter,
                  height: diameter,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorsManager.timeGradiant1,
                            ColorsManager.timeGradiant2,
                            ColorsManager.timeGradiant3,
                          ])),
                ),
                BuildVendorSessionsStack(
                  diameter: diameter,
                ),
                ClockNumbers(
                  diameter: diameter * 0.9.r,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

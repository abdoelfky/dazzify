import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/features/booking/logic/multiple_service_availability_cubit/multiple_service_availability_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/build_vendor_multiple_booking_sessions_stack.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/clock_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultipleBookingAnalogClock extends StatelessWidget {
  final double diameter;

  const MultipleBookingAnalogClock({
    required this.diameter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultipleServiceAvailabilityCubit,
        MultipleServiceAvailabilityState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context
                .read<MultipleServiceAvailabilityCubit>()
                .changeSelectedSession();
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
                      ],
                    ),
                  ),
                ),
                BuildVendorMultipleBookingSessionsStack(
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

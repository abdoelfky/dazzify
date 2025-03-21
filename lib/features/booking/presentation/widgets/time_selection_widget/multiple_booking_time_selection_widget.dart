import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/multiple_service_availability_cubit/multiple_service_availability_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/multiple_booking_analog_clock.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/day_time_button/day_time_button.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/digital_clock/multiple_booking_digital_clock.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';

class MultipleBookingTimeSelectionWidget extends StatefulWidget {
  const MultipleBookingTimeSelectionWidget({super.key});

  @override
  State<MultipleBookingTimeSelectionWidget> createState() =>
      _MultipleBookingTimeSelectionWidgetState();
}

class _MultipleBookingTimeSelectionWidgetState
    extends State<MultipleBookingTimeSelectionWidget> {
  late final MultipleServiceAvailabilityCubit _availabilityCubit;

  @override
  void initState() {
    _availabilityCubit = context.read<MultipleServiceAvailabilityCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168.h,
      child: BlocBuilder<MultipleServiceAvailabilityCubit,
          MultipleServiceAvailabilityState>(
        builder: (context, state) {
          if (state.availableSessions[AvailabilityDayTime.am]!.isEmpty &&
              state.availableSessions[AvailabilityDayTime.pm]!.isEmpty) {
            return Center(
              child: EmptyDataWidget(
                height: 50.w,
                width: 50.w,
                message: context.tr.noSessionsToday,
              ),
            );
          } else {
            return CustomFadeAnimation(
              duration: const Duration(milliseconds: 750),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16).r,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const MultipleBookingDigitalClock(),
                              SizedBox(
                                height: 8.h,
                              ),
                              SizedBox(
                                width: 150.w,
                                child: Row(
                                  children: [
                                    DayTimeButton(
                                      dayTime: AvailabilityDayTime.am,
                                      selectedDayTime: state.selectedDayTime,
                                      onDayTimeTap: () {
                                        _availabilityCubit.changeDayTime(
                                          dayTime: AvailabilityDayTime.am,
                                        );
                                      },
                                    ),
                                    DayTimeButton(
                                      dayTime: AvailabilityDayTime.pm,
                                      selectedDayTime: state.selectedDayTime,
                                      onDayTimeTap: () {
                                        _availabilityCubit.changeDayTime(
                                          dayTime: AvailabilityDayTime.pm,
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              SizedBox(
                                width: 150.w,
                                child: Center(
                                  child: DText(
                                    context.tr.pickTime,
                                    style: context.textTheme.bodySmall,
                                  ),
                                ),
                              )
                            ]),
                        MultipleBookingAnalogClock(
                          diameter: 150.w,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

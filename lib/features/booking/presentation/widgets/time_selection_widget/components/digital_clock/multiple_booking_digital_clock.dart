import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/data/models/vendor_session_model.dart';
import 'package:dazzify/features/booking/logic/multiple_service_availability_cubit/multiple_service_availability_cubit.dart';

class MultipleBookingDigitalClock extends StatefulWidget {
  const MultipleBookingDigitalClock({super.key});

  @override
  State<MultipleBookingDigitalClock> createState() =>
      _MultipleBookingDigitalClockState();
}

class _MultipleBookingDigitalClockState
    extends State<MultipleBookingDigitalClock> {
  late MultipleServiceAvailabilityCubit _availabilityCubit;

  @override
  void initState() {
    _availabilityCubit = context.read<MultipleServiceAvailabilityCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultipleServiceAvailabilityCubit,
        MultipleServiceAvailabilityState>(builder: (context, state) {
      List<VendorSessionModel> selectedDaySessions =
          state.availableSessions[state.selectedDayTime]!;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 64.w,
              height: 54.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  const Radius.circular(5.5).r,
                ),
                color: context.colorScheme.surfaceContainerHighest,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDaySessions.isEmpty
                      ? null
                      : state.selectedSession.fromTime,
                  hint: SizedBox(
                    width: 64.w,
                    height: 54.h,
                    child: Center(
                      child: DText(
                        AppConstants.zeroTime,
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  items: List.generate(
                    state.availableSessions[state.selectedDayTime]!.length,
                    (index) {
                      VendorSessionModel session = selectedDaySessions[index];
                      return DropdownMenuItem<String>(
                        onTap: () {
                          _availabilityCubit.changeSelectedSession(
                            newSessionIndex: index,
                          );
                        },
                        value: session.fromTime,
                        child: SizedBox(
                          width: 64.w,
                          height: 54.h,
                          child: Center(
                            child: DText(session.fromTime,
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: context.colorScheme.primary,
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                  dropdownColor: context.colorScheme.surfaceContainerHighest,
                  icon: const SizedBox.shrink(),
                  onChanged: (value) {},
                ),
              )),
          SizedBox(
            width: 22.w,
            child: Center(
              child: DText(
                AppConstants.twoDots,
                style: context.textTheme.headlineSmall,
              ),
            ),
          ),
          Container(
            width: 64.w,
            height: 54.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(const Radius.circular(5.5).r),
              color: context.colorScheme.surfaceContainerHighest,
            ),
            child: SizedBox(
              width: 64.w,
              height: 54.h,
              child: Center(
                child: DText(
                  state.selectedSession.toTime,
                  style: context.textTheme.bodySmall,
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}

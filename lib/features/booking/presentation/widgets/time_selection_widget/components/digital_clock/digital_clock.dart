import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/booking/data/models/vendor_session_model.dart';
import 'package:dazzify/features/booking/logic/service_availability_cubit/service_availability_cubit.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock({super.key});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late ServiceAvailabilityCubit _availabilityCubit;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    _availabilityCubit = context.read<ServiceAvailabilityCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceAvailabilityCubit, ServiceAvailabilityState>(
        builder: (context, state) {
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
                  onChanged: (value) {
                    if (value != null) {
                      _logger.logEvent(event: AppEvents.calendarSelectTime);
                    }
                  },
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

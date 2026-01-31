import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/booking/logic/multiple_service_availability_cubit/multiple_service_availability_cubit.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';

class MultipleBookingSelectionConfirmation extends StatelessWidget {
  const MultipleBookingSelectionConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final AppEventsLogger _logger = getIt<AppEventsLogger>();

    return BlocBuilder<MultipleServiceAvailabilityCubit,
        MultipleServiceAvailabilityState>(
      builder: (context, state) {
        return CustomFadeAnimation(
          duration: const Duration(milliseconds: 750),
          child: SizedBox(
              width: 328.w,
              height: 36.h,
              child: InkWell(
                onTap: () {
                  context
                      .read<MultipleServiceAvailabilityCubit>()
                      .changeSessionConfirmation(value: !state.isSessionConfirmed);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 250.w,
                      child: FittedBox(
                        child: DText(
                          context.tr.serviceSelectionConfirmation(
                            state.selectedSession.fromTime,
                            state.selectedSession.toTime,
                            state.selectedDate,
                          ),
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Checkbox(
                      value: state.isSessionConfirmed,
                      onChanged: (value) {
                        if(!state.isSessionConfirmed){
                        _logger.logEvent(
                            event: AppEvents
                                .calendarAgreeTerms);}
                        else{
                        _logger.logEvent(
                            event: AppEvents
                                .calendarCancelTerms);}
                        context
                            .read<MultipleServiceAvailabilityCubit>()
                            .changeSessionConfirmation(value: value!);
                      },
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}

import 'package:dazzify/core/framework/export.dart';

class DayTimeButton extends StatelessWidget {
  const DayTimeButton({
    required this.dayTime,
    required this.selectedDayTime,
    required this.onDayTimeTap,
    super.key,
  });

  final AvailabilityDayTime dayTime;
  final AvailabilityDayTime selectedDayTime;
  final void Function() onDayTimeTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onDayTimeTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: 27.h,
          decoration: BoxDecoration(
            color: dayTime == selectedDayTime
                ? context.colorScheme.primaryContainer
                : context.colorScheme.surfaceContainerHighest,
            borderRadius: dayTime == AvailabilityDayTime.am
                ? BorderRadius.horizontal(left: const Radius.circular(5.5).r)
                : BorderRadius.horizontal(right: const Radius.circular(5.5).r),
          ),
          child: Center(
            child: DText(
              dayTime.name,
              style: context.textTheme.bodyMedium!.copyWith(
                  color: dayTime == selectedDayTime
                      ? context.colorScheme.onPrimaryContainer
                      : context.colorScheme.outline),
            ),
          ),
        ),
      ),
    );
  }
}

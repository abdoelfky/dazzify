import 'package:dazzify/core/framework/export.dart';

class ServiceBookingButton extends StatelessWidget {
  final bool isBooked;
  final void Function()? onTap;

  const ServiceBookingButton({
    super.key,
    required this.isBooked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        // width: 130.w,
        height: 32.h,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isBooked ? null : context.colorScheme.primary,
          border: Border.all(
            color: isBooked ? context.colorScheme.primary : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isBooked
                ? Icon(
                    SolarIconsOutline.verifiedCheck,
                    color: ColorsManager.successColor,
                    size: 12.r,
                  )
                : Icon(
                    SolarIconsOutline.calendar,
                    color: context.colorScheme.onPrimary,
                    size: 12.r,
                  ),
            SizedBox(width: 16),
            DText(
              isBooked ? context.tr.serviceBooked : context.tr.bookService,
              style: context.textTheme.labelSmall!.copyWith(
                color: isBooked
                    ? context.colorScheme.primary
                    : context.colorScheme.onPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/enums/booking_status_enum.dart';

class BookingBadge extends StatelessWidget {
  final BookingStatus bookingStatus;

  const BookingBadge({super.key, required this.bookingStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DText(
          bookingStatus.name,
          style: context.textTheme.bodySmall!.copyWith(
            color: badgeColor(context),
          ),
        ),
        SizedBox(width: 8.w),
        Icon(
          badgeIcon(),
          size: 14.r,
          color: badgeColor(context),
        ),
      ],
    );
  }

  IconData badgeIcon() {
    switch (bookingStatus) {
      case BookingStatus.initial:
      case BookingStatus.pending:
        return SolarIconsOutline.clockCircle;
      case BookingStatus.confirmed:
        return SolarIconsOutline.checkCircle;
      case BookingStatus.cancelled:
        return SolarIconsOutline.closeCircle;
    }
  }

  Color badgeColor(BuildContext context) {
    switch (bookingStatus) {
      case BookingStatus.initial:
      case BookingStatus.pending:
        return context.colorScheme.primary;
      case BookingStatus.confirmed:
        return ColorsManager.successColor;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }
}

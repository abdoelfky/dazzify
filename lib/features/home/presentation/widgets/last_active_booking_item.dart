import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/data/models/last_active_booking_model.dart';
import 'package:dazzify/features/home/presentation/widgets/last_active_booking_bar.dart';
import 'package:dazzify/features/shared/enums/booking_status_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class LastActiveBookingItem extends StatefulWidget {
  final LastActiveBookingModel booking;

  const LastActiveBookingItem({super.key, required this.booking});

  @override
  State<LastActiveBookingItem> createState() => _LastActiveBookingItemState();
}

class _LastActiveBookingItemState extends State<LastActiveBookingItem> {
  late BookingStatus bookingStatus;

  @override
  void initState() {
    super.initState();
    bookingStatus = getBookingStatus(widget.booking.status);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(BookingStatusRoute(bookingId: widget.booking.id));
      },
      child: Container(
        width: 295.w,
        decoration: BoxDecoration(
          color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0).r,
          child: Stack(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: DazzifyCachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.booking.services.first.image,
                      width: 140.w,
                      height: 110.h,
                    ),
                  ),
                  SizedBox(width: 8.0.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130.w,
                        child: DText(
                          widget.booking.services.first.title,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(height: 4.0.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            SolarIconsOutline.alarm,
                            size: 14.r,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 8.0.w),
                          DText(
                            "${widget.booking.services.first.duration} ${context.tr.min}",
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0.w),
                      bookingStatus == BookingStatus.pending
                          ? LastActiveBookingProgressBar(
                              startTime: widget.booking.createdAt,
                            )
                          : bookingCompleted(context, widget.booking),
                    ],
                  ),
                ],
              ),
              bookingStatus == BookingStatus.confirmed
                  ? PositionedDirectional(
                      bottom: 10.h,
                      end: 2.w,
                      child: Row(
                        children: [
                          DText(
                            BookingStatus.confirmed.name,
                            style: context.textTheme.labelMedium!.copyWith(
                              color: ColorsManager.successColor,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Icon(
                            SolarIconsOutline.checkCircle,
                            size: 14.r,
                            color: ColorsManager.successColor,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget bookingCompleted(BuildContext context, LastActiveBookingModel booking) {
  return SizedBox(
    width: 120.w,
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: context.tr.serviceStartTime,
            style: context.textTheme.labelSmall!.copyWith(
              color: context.colorScheme.outlineVariant,
            ),
          ),
          TextSpan(
            text: TimeManager.getTimeRemaining(booking.startTime),
            style: context.textTheme.labelSmall!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/data/models/booking_service_model.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/shared/enums/booking_status_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

import 'booking_badge.dart';

class MultiBookingWidget extends StatelessWidget {
  final BookingServiceModel service;
  final BookingCubit booking;
  const MultiBookingWidget({
    required this.service,
    required this.booking,
 // Accept callback as parameter

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final serviceInfo = booking.state.singleBooking;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: 300.w,
        height: 95.h,
        decoration: BoxDecoration(
            color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25).r),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 90.h,
                width: 90.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8).r,
                  child: DazzifyCachedNetworkImage(
                    imageUrl: service.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DText(
                            service.title,
                            style: context.textTheme.bodyLarge!.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        BookingBadge(
                          bookingStatus: getBookingStatus(serviceInfo.status),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      service.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

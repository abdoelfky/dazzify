import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/data/models/last_active_booking_model.dart';
import 'package:dazzify/features/home/presentation/widgets/last_active_booking_bar.dart';
import 'package:dazzify/features/shared/enums/booking_status_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LastActiveBookingItem extends StatefulWidget {
  final LastActiveBookingModel booking;

  const LastActiveBookingItem({super.key, required this.booking});

  @override
  State<LastActiveBookingItem> createState() => _LastActiveBookingItemState();
}

class _LastActiveBookingItemState extends State<LastActiveBookingItem> {
  late BookingStatus bookingStatus;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    bookingStatus = getBookingStatus(widget.booking.status);
    _pageController = PageController();

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
                  if (widget.booking.services.length > 1)
                    Column(
                      children: [
                        SizedBox(
                          width: 140.0.w, // Adjust the width
                          height: 90.0.h,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.booking.services.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8.0).r,
                                child: DazzifyCachedNetworkImage(
                                  imageUrl: widget.booking.services[index].image,
                                  fit: BoxFit.cover,
                                  width: 140.0.w, // Adjust the width
                                  height: 90.0.h, // Adjust the height
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8.w,),
                        Center(
                          child: SmoothPageIndicator(
                            controller:
                            _pageController, // Connect the page controller
                            count: widget.booking.services.length, // The number of dots
                            effect: ScrollingDotsEffect(
                              // You can customize the dot effect here
                              activeDotColor: context.colorScheme.primary,
                              // Active dot color
                              dotColor: Colors.grey,
                              // Inactive dot color
                              dotHeight: 8.0.h,
                              // Height of the dot
                              dotWidth: 8.0.h,
                              // Width of the dot
                              spacing: 8.0.w, // Space between dots
                            ),
                          ),
                        ),

                      ],
                    ),

                  if (widget.booking.services.length == 1)
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
                            SolarIconsOutline.calendar,
                            size: 14.r,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 8.0.w),
                          DText(
                            TimeManager.formatBookingDateTime(
                                widget.booking.startTime),
                            style: context.textTheme.bodySmall,
                          ),
                        ],
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
                            TimeManager.formatServiceDuration(
                                widget.booking.services.fold(
                                    0,
                                    (total, service) =>
                                        total + service.duration),
                                context),
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0.w),
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
                      bottom: 5.h,
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
  final String serviceTime = TimeManager.getTimeRemaining(booking.startTime);
  return SizedBox(
    width: 120.w,
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: serviceTime != ""
                ? context.tr.serviceStartTime
                : context.tr.serviceStartNow,
            style: context.textTheme.labelSmall!.copyWith(
              color: serviceTime != ""
                  ? context.colorScheme.outlineVariant
                  : context.colorScheme.primary,
            ),
          ),
          TextSpan(
            text: serviceTime,
            style: context.textTheme.labelSmall!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    ),
  );
}

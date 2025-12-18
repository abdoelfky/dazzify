import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
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
  int _currentPageIndex = 0;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    super.initState();
    bookingStatus = getBookingStatus(widget.booking.status);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.booking.services;

    return GestureDetector(
      onTap: () {
        _logger.logEvent(
          event: AppEvents.homeClickBookingStatus,
          bookingId: widget.booking.id,
        );
        context.pushRoute(BookingStatusRoute(bookingId: widget.booking.id));
      },
      child: Container(
        width: 295.w,
        decoration: BoxDecoration(
          color: context.colorScheme.inversePrimary.withAlpha(25),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0).r,
          child: Stack(
            children: [
              Row(
                children: [
                  if (services.length > 1)
                    Column(
                      children: [
                        SizedBox(
                          width: 140.w,
                          height: 90.h,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: services.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: DazzifyCachedNetworkImage(
                                      imageUrl: services[index].image,
                                      fit: BoxFit.cover,
                                      width: 140.w,
                                      height: 90.h,
                                    ),
                                  ),
                                  // if (service.quantity > 1)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.r, vertical: 2.r),
                                      decoration: BoxDecoration(
                                        color:
                                            context.colorScheme.inversePrimary,
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      child: DText(
                                          'X${services[index].quantity}',
                                          style: context.textTheme.bodyMedium!
                                              .copyWith(
                                                  color: context.colorScheme
                                                      .onSecondary)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8.w),
                        Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: services.length,
                            effect: ScrollingDotsEffect(
                              activeDotColor: context.colorScheme.primary,
                              dotColor: Colors.grey,
                              dotHeight: 4.h,
                              dotWidth: 20.h,
                              spacing: 8.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (services.length == 1)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: DazzifyCachedNetworkImage(
                            imageUrl: services.first.image,
                            fit: BoxFit.cover,
                            width: 140.w,
                            height: 90.h,
                          ),
                        ),
                        // if (service.quantity > 1)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.r, vertical: 2.r),
                            decoration: BoxDecoration(
                              color: context.colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: DText('X${services.first.quantity}',
                                style: context.textTheme.bodyMedium!.copyWith(
                                    color: context.colorScheme.onSecondary)),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130.w,
                        child: services.length > 1
                            ? Text(
                                services[_currentPageIndex].title,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyMedium,
                              )
                            : Text(
                                services.first.title,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyMedium,
                              ),
                      ),
                      SizedBox(height: 4.w),
                      // You can also update date/time and duration for the current service if needed,
                      // or keep it as booking-level info if that's intended.
                      // For now, keeping the same booking info:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            SolarIconsOutline.calendar,
                            size: 14.r,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 8.w),
                          DText(
                            TimeManager.formatBookingDateTime(
                                widget.booking.startTime),
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            SolarIconsOutline.alarm,
                            size: 14.r,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 8.w),
                          DText(
                            TimeManager.formatServiceDuration(
                              widget
                                  .booking.services[_currentPageIndex].duration,
                              context,
                            ),
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.w),
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
            text: serviceTime == DazzifyApp.tr.inProgress
                ? context.tr.service
                : serviceTime != ""
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

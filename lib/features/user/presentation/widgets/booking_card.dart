import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/data/models/bookings_list_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class BookingCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int price;
  final String startTime;
  final List<BookingService> services;

  const BookingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.startTime,
    required this.services,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isMultiple = widget.services.length > 1;
    final currentService =
    isMultiple ? widget.services[_currentIndex] : widget.services.first;

    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8).r,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10).r,
                child: SizedBox(
                  height: 80.h,
                  width: 70.w,
                  child: isMultiple
                      ? CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: widget.services.length,
                    itemBuilder: (context, index, _) {
                      final service = widget.services[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.0).r,
                            child: DazzifyCachedNetworkImage(
                              imageUrl: service.image,
                              fit: BoxFit.cover,
                              height: 80.h,
                              width: 70.w,
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
                                  'X${service.quantity}',
                                  style: context.textTheme.bodyMedium!
                                      .copyWith(
                                      color: context.colorScheme
                                          .onSecondary),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      enlargeFactor: 0.65.r,
                      viewportFraction: 1.1.r,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4).r,
                        child: DazzifyCachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          height: 80.h,
                          width: 70.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // if (currentService.quantity > 1)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.r, vertical: 2.r),
                            decoration: BoxDecoration(
                              color:
                              context.colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: DText(
                              'X${currentService.quantity}',
                              style: context.textTheme.bodyMedium!
                                  .copyWith(
                                  color: context
                                      .colorScheme.onSecondary),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: DText(
                        currentService.title ?? widget.title,
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: context.colorScheme.primary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: reformatPriceWithCommas(
                                currentService.price * currentService.quantity)
                                .toString(),
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text: " ${context.tr.egp}",
                            style: context.textTheme.bodySmall!.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (isMultiple)
                            TextSpan(
                              text:
                              "   ( ${widget.services.length} ${context.tr.services} ) ",
                              style: context.textTheme.bodySmall!.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          PositionedDirectional(
            bottom: 6.h,
            end: 8.w,
            child: DText(
              TimeManager.formatBookingDateTime(widget.startTime),
              style: context.textTheme.bodySmall!.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

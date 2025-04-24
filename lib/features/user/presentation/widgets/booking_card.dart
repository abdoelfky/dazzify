import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/data/models/bookings_list_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class BookingCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
              if (services.length > 1)
                Padding(
                  padding: const EdgeInsets.all(10).r,
                  child: SizedBox(
                    height: 80.h,
                    width: 70.w,
                    child: CarouselSlider.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index, realIndex) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(4.0).r,
                          child: DazzifyCachedNetworkImage(
                            imageUrl: services[index].image,
                            fit: BoxFit.cover,
                            height: 80.h,
                            width: 70.w, // Adjust the height
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        // Enable auto-play
                        autoPlayInterval: const Duration(seconds: 3),
                        // Set auto-play interval
                        enlargeCenterPage: true,
                        // Enlarge the center page for focus
                        enlargeFactor: 0.65.r,
                        // Increase the size of the central item
                        viewportFraction: 1.1
                            .r, // Set the portion of the screen occupied by the current item
                      ),
                    ),
                  ),
                ),
              if (services.length == 1)
                Padding(
                  padding: const EdgeInsets.all(10).r,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4).r,
                    child: DazzifyCachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 80.h,
                      width: 70.w,
                      fit: BoxFit.cover,
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
                        title,
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
                            text: services
                                .fold(0,
                                    (total, service) => total + service.price)
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
                          TextSpan(
                            text: services.length > 1
                                ? "   ( ${services.length} ${context.tr.services} ) "
                                : "",
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
              TimeManager.formatBookingDateTime(startTime),
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

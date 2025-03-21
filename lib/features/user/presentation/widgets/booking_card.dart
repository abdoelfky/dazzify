import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class BookingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int price;
  final String startTime;

  const BookingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.startTime,
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
                    DText(
                      title,
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: price.toString(),
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

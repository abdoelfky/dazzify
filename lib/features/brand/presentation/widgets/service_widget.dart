import 'dart:ui';

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/brand/presentation/widgets/service_booking_button.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class ServiceWidget extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final num price;
  final void Function()? onSingleBookingTap;
  final ServiceStatus serviceStatus;
  final bool isMultipleService;
  final bool isBooked;
  final void Function()? onBookingSelectTap;
  final void Function()? onCardTap;

  const ServiceWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    this.onSingleBookingTap,
    required this.serviceStatus,
    this.isMultipleService = false,
    this.isBooked = false,
    this.onBookingSelectTap,
    this.onCardTap,
  });

  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCardTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16).r,
            child: Container(
              height: 140.h,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)).r,
                color:
                    context.colorScheme.inversePrimary.withValues(alpha: 0.1),
              ),
              child: Row(
                children: [
                  serviceImage(),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 69.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DText(
                                widget.title,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyLarge!.copyWith(
                                  height: 0.9.h,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              DText(
                                widget.description,
                                maxLines: 3,
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                  height: 0.9.h,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                              widget.serviceStatus != ServiceStatus.confirmation
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 62.r,
                              height: 16.r,
                              child: FittedBox(
                                alignment: AlignmentDirectional.centerStart,
                                child: DText(
                                  '${widget.price} ${context.tr.egp}',
                                  style: context.textTheme.titleSmall,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.r,
                            ),
                            if (widget.serviceStatus !=
                                ServiceStatus.confirmation)
                              Builder(
                                builder: (context) {
                                  if (widget.isMultipleService) {
                                    return ServiceBookingButton(
                                      isBooked: widget.isBooked,
                                      onTap: widget.onBookingSelectTap,
                                    );
                                  } else {
                                    return PrimaryButton(
                                      width: 130.r,
                                      height: 32.r,
                                      onTap: () {
                                        if (widget.onSingleBookingTap != null) {
                                          widget.onSingleBookingTap!();
                                        }
                                      },
                                      title: getButtonTitle(
                                        context,
                                        widget.serviceStatus,
                                      ),
                                      titleStyle: context.textTheme.labelSmall!
                                          .copyWith(
                                        color: context.colorScheme.onPrimary,
                                      ),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (widget.serviceStatus == ServiceStatus.pending) pendingFilter()
        ],
      ),
    );
  }

  Widget serviceImage() {
    return SizedBox(
      height: 108.h,
      width: 80.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8).r,
        child: DazzifyCachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String getButtonTitle(BuildContext context, ServiceStatus serviceStatus) {
    if (serviceStatus == ServiceStatus.booking) {
      return context.tr.book;
    } else if (serviceStatus == ServiceStatus.paying) {
      return context.tr.payService;
    } else if (serviceStatus == ServiceStatus.pending) {
      return context.tr.pending;
    } else {
      return '';
    }
  }

  Widget pendingFilter() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 1,
          sigmaY: 1,
        ),
        child: Container(
          height: 140.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(const Radius.circular(8).r),
            color: context.colorScheme.surface.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}

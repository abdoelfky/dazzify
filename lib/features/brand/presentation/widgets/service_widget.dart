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
  final int quantity;
  final void Function()? onSingleBookingTap;
  final ServiceStatus serviceStatus;
  final bool isMultipleService;
  final bool isAllowMultipleServicesCount;
  final bool isBooked;
  final void Function()? onBookingSelectTap;
  final void Function()? onCardTap;

  /// Optional: callback to update quantity in parent
  final Function(int)? onQuantityChanged;

  const ServiceWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.serviceStatus,
    required this.quantity,
    this.onSingleBookingTap,
    this.isMultipleService = false,
    this.isAllowMultipleServicesCount = false,
    this.isBooked = false,
    this.onBookingSelectTap,
    this.onCardTap,
    this.onQuantityChanged,
  });

  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  late int quantity;

  @override
  void initState() {
    quantity = widget.quantity;
    super.initState();
  }

  void _increment() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged?.call(quantity);
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged?.call(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCardTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16).r,
            child: Container(
              height: 150.h,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)).r,
                color: context.colorScheme.onInverseSurface,
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Expanded(child: serviceImage()),
                      if ((widget.isAllowMultipleServicesCount &&
                              widget.isBooked) ||
                          (!widget.isMultipleService &&
                              widget.isAllowMultipleServicesCount))
                        Column(
                          children: [
                            SizedBox(height: 8.w),
                            DText(
                              '${reformatPriceWithCommas(widget.price)} ${context.tr.egp}',
                              style: context.textTheme.labelLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                    ],
                  ),
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
                              Expanded(
                                child: DText(
                                  widget.description,
                                  maxLines: 3,
                                  style: context.textTheme.bodySmall!.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                    height: 1.h,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                            if (widget.isMultipleService &&
                                widget.isAllowMultipleServicesCount &&
                                !widget.isBooked)
                              SizedBox(
                                width: 62.r,
                                height: 16.r,
                                child: FittedBox(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: DText(
                                    '${reformatPriceWithCommas(widget.price)} ${context.tr.egp}',
                                    style: context.textTheme.labelLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            if ((widget.isAllowMultipleServicesCount &&
                                    widget.isBooked) ||
                                (!widget.isMultipleService &&
                                    widget.isAllowMultipleServicesCount))
                              incDecButton(
                                context,
                                quantity,
                                _increment,
                                _decrement,
                              ),
                            SizedBox(width: 8.r),
                            if (widget.serviceStatus !=
                                ServiceStatus.confirmation)
                              Builder(
                                builder: (context) {
                                  if (widget.isMultipleService) {
                                    return Expanded(
                                      child: ServiceBookingButton(
                                        isBooked: widget.isBooked,
                                        onTap: widget.onBookingSelectTap,
                                      ),
                                    );
                                  } else {
                                    return PrimaryButton(
                                      width: 130.r,
                                      height: 32.r,
                                      onTap: () {
                                        widget.onSingleBookingTap?.call();
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
    switch (serviceStatus) {
      case ServiceStatus.booking:
        return context.tr.book;
      case ServiceStatus.paying:
        return context.tr.payService;
      case ServiceStatus.pending:
        return context.tr.pending;
      default:
        return '';
    }
  }

  Widget pendingFilter() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          height: 140.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8).r),
            color: context.colorScheme.surface.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}

Widget incDecButton(
  BuildContext context,
  int quantity,
  VoidCallback onIncrement,
  VoidCallback onDecrement,
) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.r),
      color: context.colorScheme.inversePrimary.withValues(alpha: 0.05),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildCircleButton(
            icon: Icons.remove, onTap: onDecrement, context: context),
        SizedBox(width: 8.w),
        DText(
          '$quantity',
          style: context.textTheme.labelLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8.w),
        buildCircleButton(
            icon: Icons.add, onTap: onIncrement, context: context),
      ],
    ),
  );
}

Widget buildCircleButton(
    {required IconData icon,
    required VoidCallback onTap,
    required BuildContext context}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: context.colorScheme.primary),
      ),
      child: Center(
          child: Icon(icon, size: 14.r, color: context.colorScheme.primary)),
    ),
  );
}

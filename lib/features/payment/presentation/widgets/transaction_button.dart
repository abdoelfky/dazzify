import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/shared/enums/transaction_enum.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

class TransactionButton extends StatefulWidget {
  final String status;
  final String serviceName;
  final String transactionId;
  final double? amount;

  const TransactionButton({
    super.key,
    required this.status,
    required this.serviceName,
    required this.transactionId,
    this.amount,
  });

  @override
  State<TransactionButton> createState() => _TransactionButtonState();
}

class _TransactionButtonState extends State<TransactionButton> {
  late PaymentStatus paymentStatus;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    super.initState();
    paymentStatus = getPaymentStatus(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    switch (paymentStatus) {
      case PaymentStatus.none:
      case PaymentStatus.cancelled:
        return const SizedBox.shrink();
      case PaymentStatus.notPaid:
        final String buttonTitle = widget.amount != null
            ? '${context.tr.pay} ${widget.amount!.toInt()} ${context.tr.egp}'
            : context.tr.pay;

        return PrimaryButton(
          width: widget.amount != null ? null : 100.w,
          height: 40.h,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(8),
            bottomLeft: Radius.circular(32),
          ).r,
          title: buttonTitle,
          onTap: () {
            // Check if this is from booking status screen
            final routeName = ModalRoute.of(context)?.settings.name ?? '';
            if (routeName.contains('BookingStatus') ||
                routeName.contains('booking-status')) {
              _logger.logEvent(
                event: AppEvents.bookingStatusClickPay,
                transactionId: widget.transactionId,
              );
            } else {
              _logger.logEvent(
                event: AppEvents.paymentsClickPay,
                transactionId: widget.transactionId,
              );
            }
            context.router.root
                .push(
              PaymentMethodRoute(
                serviceName: widget.serviceName,
                transactionId: widget.transactionId,
              ),
            )
                .then((onValue) {
              setState(() {
                paymentStatus = getPaymentStatus(widget.status);
              });
            });
          },
        );
      case PaymentStatus.refunded:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              SolarIconsOutline.banknote2,
              color: context.colorScheme.outlineVariant,
              size: 12.r,
            ),
            SizedBox(width: 2.w),
            DText(
              context.tr.refund,
              style: context.textTheme.bodySmall!.copyWith(
                color: context.colorScheme.outlineVariant,
              ),
            ),
          ],
        );
      case PaymentStatus.pendingRefund:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              SolarIconsOutline.clockCircle,
              color: context.colorScheme.secondary,
              size: 12.r,
            ),
            SizedBox(width: 2.w),
            DText(
              context.tr.pendingRefund,
              style: context.textTheme.bodySmall!.copyWith(
                color: context.colorScheme.secondary,
              ),
            ),
          ],
        );
      case PaymentStatus.refundInReview:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              SolarIconsOutline.documentText,
              color: context.colorScheme.tertiary,
              size: 12.r,
            ),
            SizedBox(width: 2.w),
            DText(
              context.tr.refundInReview,
              style: context.textTheme.bodySmall!.copyWith(
                color: context.colorScheme.tertiary,
              ),
            ),
          ],
        );
      case PaymentStatus.paid:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              SolarIconsOutline.checkCircle,
              color: ColorsManager.successColor,
              size: 12.r,
            ),
            SizedBox(width: 2.w),
            DText(
              context.tr.paid,
              style: context.textTheme.bodySmall!.copyWith(
                color: ColorsManager.successColor,
              ),
            ),
          ],
        );
    }
  }
}

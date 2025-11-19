import 'package:dazzify/core/framework/export.dart';
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
            context.router
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

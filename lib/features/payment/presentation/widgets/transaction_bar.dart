import 'dart:async';

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/payment/data/models/transaction_model.dart';
import 'package:dazzify/features/shared/enums/transaction_enum.dart';

class TransactionBar extends StatefulWidget {
  final TransactionModel transaction;
  final void Function() onTimerFinish;

  const TransactionBar({
    super.key,
    required this.transaction,
    required this.onTimerFinish,
  });

  @override
  State<TransactionBar> createState() => _TransactionBarState();
}

class _TransactionBarState extends State<TransactionBar> {
  Timer? _timer;
  late Duration remainingTime;
  late Duration totalTime;
  late PaymentStatus paymentStatus;

  @override
  void initState() {
    super.initState();
    paymentStatus = getPaymentStatus(widget.transaction.status);
    _initializeTimer();
    if (paymentStatus == PaymentStatus.notPaid) {
      _startTimer();
    }
  }

  void _initializeTimer() {
    DateTime currentTime = DateTime.now();

    DateTime startTime = DateTime.parse(widget.transaction.createdAt).toLocal();
    DateTime expireTime =
        DateTime.parse(widget.transaction.expiredAt).toLocal();

    totalTime = expireTime.difference(startTime);
    remainingTime = expireTime.difference(currentTime);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          remainingTime = remainingTime - const Duration(minutes: 1);
          if (remainingTime.inMinutes <= 0) {
            widget.onTimerFinish();
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (paymentStatus) {
      case PaymentStatus.none:
      case PaymentStatus.paid:
      case PaymentStatus.cancelled:
        return const SizedBox.shrink();
      case PaymentStatus.notPaid:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(32).r,
                    backgroundColor: context.colorScheme.outline,
                    color: context.colorScheme.primary,
                    value: TimeManager.calculateProgress(
                      remainingTime: remainingTime,
                      totalDuration: totalTime,
                    ),
                    minHeight: 8.h,
                  ),
                ),
                SizedBox(width: 4.w),
                DText(
                  TimeManager.formatDuration(remainingTime),
                  style: context.textTheme.labelSmall!.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            DText(
              context.tr.expirationDate,
              style: context.textTheme.labelSmall!.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ],
        );
      case PaymentStatus.refunded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 8.r,
                  backgroundColor: context.colorScheme.primaryContainer,
                ),
                SizedBox(width: 8.w),
                DText(
                  context.tr.paidAmount,
                  style: context.textTheme.labelSmall,
                ),
                SizedBox(width: 49.w),
                DText(
                  "${widget.transaction.amount.toString()} ${context.tr.egp}",
                  style: context.textTheme.labelSmall!.copyWith(
                    color: ColorsManager.successColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 8.r,
                  backgroundColor: context.colorScheme.outlineVariant,
                ),
                SizedBox(width: 8.w),
                DText(
                  context.tr.refundAmount,
                  style: context.textTheme.labelSmall,
                ),
                SizedBox(width: 49.w),
                DText(
                  "${widget.transaction.refundAmount.toString()} ${context.tr.egp}",
                  style: context.textTheme.labelSmall!.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

import 'package:dazzify/dazzify_app.dart';

enum TransactionType {
  none,
  down,
  last,
}

enum PaymentStatus {
  none,
  paid,
  notPaid,
  refunded,
  cancelled,
  pendingRefund,
  refundInReview,
}

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.none:
        return "";
      case TransactionType.down:
        return DazzifyApp.tr.downPayment;
      case TransactionType.last:
        return DazzifyApp.tr.lastPayment;
    }
  }
}

TransactionType getTransactionType(String value) {
  switch (value) {
    case "":
      return TransactionType.none;
    case "down":
      return TransactionType.down;
    case "last":
      return TransactionType.last;
    default:
      return TransactionType.none;
  }
}

PaymentStatus getPaymentStatus(String value) {
  switch (value) {
    case "":
      return PaymentStatus.none;
    case "paid":
      return PaymentStatus.paid;
    case "not paid":
      return PaymentStatus.notPaid;
    case "refunded":
      return PaymentStatus.refunded;
    case "cancelled":
      return PaymentStatus.cancelled;
    case "pending_refund":
      return PaymentStatus.pendingRefund;
    case "refund_in_review":
      return PaymentStatus.refundInReview;
    default:
      return PaymentStatus.none;
  }
}

extension PaymentStatusExtension on PaymentStatus {
  String get name {
    switch (this) {
      case PaymentStatus.none:
        return "";
      case PaymentStatus.paid:
        return "paid";
      case PaymentStatus.notPaid:
        return "not paid";
      case PaymentStatus.refunded:
        return "refunded";
      case PaymentStatus.cancelled:
        return "cancelled";
      case PaymentStatus.pendingRefund:
        return "pending_refund";
      case PaymentStatus.refundInReview:
        return "refund_in_review";
    }
  }
}

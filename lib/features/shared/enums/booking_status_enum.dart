import 'package:dazzify/dazzify_app.dart';

enum BookingStatus { initial, pending, confirmed, cancelled }

extension BookingStatusExtension on BookingStatus {
  String get key {
    switch (this) {
      case BookingStatus.initial:
        return "";
      case BookingStatus.pending:
        return "pending";
      case BookingStatus.confirmed:
        return "confirmed";
      case BookingStatus.cancelled:
        return "cancelled";
    }
  }

  String get name {
    switch (this) {
      case BookingStatus.initial:
        return "";
      case BookingStatus.pending:
        return DazzifyApp.tr.pending;
      case BookingStatus.confirmed:
        return DazzifyApp.tr.accepted;
      case BookingStatus.cancelled:
        return DazzifyApp.tr.canceled;
    }
  }
}

BookingStatus getBookingStatus(String? value) {
  switch (value) {
    case '':
      return BookingStatus.initial;
    case 'pending':
      return BookingStatus.pending;
    case 'confirmed':
      return BookingStatus.confirmed;
    case 'cancelled':
      return BookingStatus.cancelled;
    default:
      return BookingStatus.initial;
  }
}

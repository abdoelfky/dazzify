enum NotificationTypeEnum {
  general,
  newMessage,
  bookingStatus,
  payment,
  ban,
  issueStatus
}

NotificationTypeEnum getNotificationType(String? value) {
  switch (value) {
    case 'GENERAL':
      return NotificationTypeEnum.general;
    case 'NEW_MESSAGE':
      return NotificationTypeEnum.newMessage;
    case 'BOOKING_STATUS':
      return NotificationTypeEnum.bookingStatus;
    case 'PAYMENT':
      return NotificationTypeEnum.payment;
    case 'BAN':
      return NotificationTypeEnum.ban;
    case 'ISSUE_STATUS':
      return NotificationTypeEnum.issueStatus;
    default:
      return NotificationTypeEnum.general;
  }
}

enum UiState { initial, loading, failure, success }

enum UILoadingType { skeleton, overlay, content }

enum MediaType {
  album,
  photo,
  video,
  none,
}

MediaType getMediaType(String value) {
  switch (value) {
    case '':
      return MediaType.none;
    case 'photo':
      return MediaType.photo;
    case 'video':
      return MediaType.video;
    case 'album':
      return MediaType.album;
    default:
      return MediaType.none;
  }
}

enum CardImageType {
  none,
  photo,
  album,
}

CardImageType getCardImageType(String value) {
  switch (value) {
    case '':
      return CardImageType.none;
    case 'photo':
      return CardImageType.photo;
    case 'album':
      return CardImageType.album;
    default:
      return CardImageType.none;
  }
}

enum BrandsSorting {
  pointsAsc,
  pointsDesc,
  ratingAsc,
  ratingDesc,
  bookingAsc,
  bookingDesc,
}

enum PermissionsState {
  initial,
  granted,
  denied,
  permanentlyDenied,
}

enum ServiceStatus {
  booking,
  paying,
  confirmation,
  pending,
}

enum MessageType {
  txt,
  photo,
  service,
}

enum Sender {
  user,
  branch,
}

enum BranchesSheetType {
  chat,
  mapLocations,
}

enum AvailabilityDayTime {
  am,
  pm,
}

extension TimeStampDayTimeExtension on String {
  AvailabilityDayTime toAvailabilityDayTime() {
    // Parse the timestamp into a DateTime object
    final dateTime = DateTime.parse(this).toLocal();

    // Extract the hour and determine AM or PM
    final hour = dateTime.hour;
    return hour < 12 ? AvailabilityDayTime.am : AvailabilityDayTime.pm;
  }
}

class ServiceLocationOptions {
  static String inBranch = 'in';
  static String outBranch = 'out';
  static String any = 'any';
}

enum CommentType {
  mainComment,
  parentComment,
  replyComment,
}

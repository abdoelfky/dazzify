import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/dazzify_app.dart';
import 'package:dazzify/features/booking/data/models/booking_service_model.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:intl/intl.dart';

import '../../features/home/data/models/service_model.dart';
import '../framework/export.dart';

class TimeManager {
  static SettingsCubit settingsCubit = getIt<SettingsCubit>();

  static String dateTimeOrTime(String dateTimeString) {
    /*
    this method checks the input timeStamp...
    
    if the date of the stamp is today, it returns ONLY the time 
    in 12H system, for example (9:50 Am)

    if the date of the stamp is not today, it returns the date alog 
    with the time, for example (Jan 13, 9:50 Am)
    */
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();

    DateTime now = DateTime.now().toLocal();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat('h:mm a', 'en_US').format(dateTime);
    } else {
      return DateFormat('MMM d, h:mm a', 'en_US').format(dateTime);
    }
  }
  static String reformatDateToDDMMYYYYWithSlashes(String date) {
    /*
   Converts a date string from DD:MM:YYYY (with colons) to DD/MM/YYYY (with slashes)
   Example: '21:03:2003' -> '21/03/2003'
  */
    if (date.contains(':')) {
      List<String> parts = date.split(':');
      if (parts.length == 3) {
        String day = parts[0].padLeft(2, '0');
        String month = parts[1].padLeft(2, '0');
        String year = parts[2];
        return '$day/$month/$year';
      }
    }
    return date; // return as is if format unexpected
  }

  static String reformatDateToDDMMYYYY(String date) {
    /*
  This method converts a date string from 'DD/MM/YYYY' to 'DD:MM:YYYY' format.
  Example: '18/10/2000' -> '18:10:2000' or '21/3/2010' -> '21:03:2010'
  */
    if (date.contains('/')) {
      List<String> parts = date.split('/');
      String day = parts[0].padLeft(2, '0');  // Ensure day has two digits
      String month = parts[1].padLeft(2, '0');  // Ensure month has two digits
      String year = parts[2];
      return '$day:$month:$year';  // Return in DD:MM:YYYY format
    }
    return date; // Return the original string if it's not in the expected 'DD/MM/YYYY' format
  }
  static String dateOrTime(String dateTimeString) {
    /*
    this method checks the input timeStamp...
    
    if the date of the stamp is today, it returns ONLY the time 
    in 12H system, for example (9:50 Am)

    if the date of the stamp is not today, it returns ONLY the date, 
    for example (Jan 13)
    */

    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();

    DateTime now = DateTime.now().toLocal();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat('h:mm a', 'en_US').format(dateTime);
    } else {
      return DateFormat('MMM d', 'en_US').format(dateTime);
    }
  }

  static String to12HFormat(String timeIn24H) {
    /*
    this funtion converts the time string formatted in 24H into 14H
    time string, for example it converts '2024-07-15T013:30:00' to '1:30 PM'.
    */

    String formattedString = timeIn24H;
    String arbitraryDate = '2020-07-20T';

    //if the time is NOT complete timeStamp (for example: '13:30:00'),
    //complete it with any arbitrary date
    if (!timeIn24H.contains('-')) {
      formattedString = '$arbitraryDate$timeIn24H';
    }

    DateTime dateTime = DateTime.parse(formattedString).toLocal();
    return DateFormat("h:mm a", 'en_US').format(dateTime);
  }

  static String extractDate(String timeStamp) {
    /*
    this function extracts the ONLY dates from the complete timeStamp.
    for example, extract '2024-07-15' from '2024-07-15T013:30:00'.
     */
    DateTime dateTime = DateTime.parse(timeStamp).toLocal();
    return DateFormat('yyyy-MM-dd', 'en_US').format(dateTime);
  }

  static String dayOrDate(String timeStamp) {
    String now = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    DateTime nowDate = DateTime.parse(now).toLocal();

    DateTime otherInUTC = DateTime.parse(timeStamp).toLocal();
    String other = DateFormat('yyyy-MM-dd', 'en_US').format(otherInUTC);
    DateTime otherDate = DateTime.parse(other).toLocal();

    int dayDifference = nowDate.difference(otherDate).inDays;

    if (dayDifference == 0) {
      return AppConstants.today;
    } else if (dayDifference == 1) {
      return AppConstants.yesterday;
    } else if (dayDifference < 8) {
      return DateFormat('EEEE', 'en_US').format(otherDate);
    } else {
      return DateFormat('yyyy-MM-dd', 'en_US').format(otherDate);
    }
  }

  static String toLocal(String timeStamp) {
    DateTime dateTime = DateTime.parse(timeStamp).toLocal();
    return dateTime.toString();
  }

  static String extractYearMonth(String timeStamp) {
    /*
    this function extract the year and the month of the timestamp
    example:
    it extracts '2025-01' from '2025-01-15T013:30:00'
    */
    DateTime dateTime = DateTime.parse(timeStamp).toLocal();
    return DateFormat('yyyy-MM', 'en_US').format(dateTime);
  }

  static String extractDay(String timeStamp) {
    /*
    this function extract the day from the timestamp
    example:
    it extracts '01' from '2025-01-15T013:30:00'
    */
    DateTime dateTime = DateTime.parse(timeStamp).toLocal();
    return DateFormat('dd', 'en_US').format(dateTime);
  }

  static String extractDayName(String timeStamp) {
    DateTime dateTime = DateTime.parse(timeStamp).toLocal();
    String locale = settingsCubit.currentLanguageCode;
    return DateFormat('EEEE', locale).format(dateTime);
  }

  static String extractYear(String timeStamp) {
    /*
    this function extract the year from the timestamp
    example:
    it extracts 2025 from '2025-01-15T013:30:00'
    */
    DateTime dateTime = DateTime.parse(timeStamp).toLocal();

    return DateFormat('yyyy', 'en_US').format(dateTime);
  }

  static String extractMonth(String timeStamp) {
    /*
    this function extract the month from the timestamp
    example:
    it extracts 1 from '2025-01-15T013:30:00'
    */
    DateTime dateTime = DateTime.parse(timeStamp).toLocal();

    return DateFormat('MM', 'en_US').format(dateTime);
  }

  //////  BOOKING STATUS

  static String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    DateTime now = DateTime.now().toLocal();

    Duration difference = now.difference(dateTime);
    if (difference.inHours < 24) {
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else {
      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        // If the date is today, format the time only
        return DateFormat('h:mm a').format(dateTime);
      } else {
        // If the date is not today, format the full date and time
        return DateFormat('MMM d, h:mm a').format(dateTime);
      }
    }
  }

  static String formatBookingDateTime(String date) {
    /*
    This Method Extract Date and Time of Booking
    - May 21, 09:23 am
    * */
    DateTime dateTime = DateTime.parse(date).toLocal();
    return DateFormat('MMM d, h:mm a').format(dateTime);
  }

  static String bookingDuration(BookingCubit booking) {
    /*
  This Method Calculates the duration of booking and shows it like:
  - 30 Min from 9:00 AM to 10:00 AM on 2025 - 02 - 02
  */
    final bookingInfo = booking.state.singleBooking;
    int bookingDuration = bookingInfo.services.first.duration;

    DateTime startTime = DateTime.parse(bookingInfo.startTime).toLocal();
    DateTime endTime = DateTime.parse(bookingInfo.endTime).toLocal();

    String startTimeFormat = DateFormat('h:mm a').format(startTime);
    String endTimeFormat = DateFormat('h:mm a').format(endTime);
    String dateFormat = DateFormat('yyyy - MM - dd').format(startTime);

    return "$bookingDuration ${DazzifyApp.tr.min} ${DazzifyApp.tr.from} $startTimeFormat ${DazzifyApp.tr.to} $endTimeFormat"
        "\n ${DazzifyApp.tr.on} $dateFormat";
  }

  static String bookingDurationForService({
    required String bookingStartTime,
    required int serviceIndex,
    required List<BookingServiceModel> services,
  }) {
    // Parse booking start time
    DateTime bookingStart = DateTime.parse(bookingStartTime).toLocal();

    // Calculate service start time by adding durations of previous services
    int previousDuration = 0;
    for (int i = 0; i < serviceIndex; i++) {
      previousDuration += services[i].duration;
    }

    DateTime serviceStart = bookingStart.add(Duration(minutes: previousDuration));
    DateTime serviceEnd = serviceStart.add(Duration(minutes: services[serviceIndex].duration));

    // Format times
    String startTimeFormat = DateFormat('h:mm a').format(serviceStart);
    String endTimeFormat = DateFormat('h:mm a').format(serviceEnd);
    String dateFormat = DateFormat('yyyy - MM - dd').format(serviceStart);

    int serviceDuration = services[serviceIndex].duration;

    // Format duration as "Xh Ym" or "Ym"
    String formattedDuration;
    if (serviceDuration < 60) {
      formattedDuration = "$serviceDuration ${DazzifyApp.tr.min}";
    } else {
      int hours = serviceDuration ~/ 60;
      int minutes = serviceDuration % 60;
      if (minutes > 0) {
        formattedDuration = "${hours}h ${minutes}m";
      } else {
        formattedDuration = "${hours}h";
      }
    }

    return "$formattedDuration ${DazzifyApp.tr.from} $startTimeFormat ${DazzifyApp.tr.to} $endTimeFormat"
        "\n${DazzifyApp.tr.on} $dateFormat";
  }



  static void initializeTimer({
    required String startTime,
    required Duration totalDuration,
    required Duration remainingTime,
  }) {
    // add 12 h to the booking created time
    DateTime startDateTime = DateTime.parse(startTime).toLocal();
    DateTime endTime = startDateTime.add(const Duration(hours: 12));
    totalDuration = endTime.difference(startDateTime);
    remainingTime = endTime.difference(DateTime.now());
  }

  static String formatDuration(Duration duration) {
    /*
    This Method Adds Text Format Duration Timer
    - 00 D : 09 H : 34 M : 12 S
    */
    // If duration is negative or zero, return zeros
    if (duration.isNegative || duration.inSeconds <= 0) {
      return '00 ${DazzifyApp.tr.daysShortcut} : '
          '00 ${DazzifyApp.tr.hoursShortcut} : '
          '00 ${DazzifyApp.tr.minShortcut}';
    }
    
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    return '${days.toString().padLeft(2, '0')} ${DazzifyApp.tr.daysShortcut} : '
        '${hours.toString().padLeft(2, '0')} ${DazzifyApp.tr.hoursShortcut} : '
        '${minutes.toString().padLeft(2, '0')} ${DazzifyApp.tr.minShortcut}';
  }

  static double calculateProgress({
    required Duration totalDuration,
    required Duration remainingTime,
  }) {
    // Handle edge cases to prevent division by zero or invalid progress values
    if (totalDuration.inMinutes <= 0) {
      return 0.0;
    }
    
    if (remainingTime.isNegative || remainingTime.inSeconds <= 0) {
      return 0.0;
    }
    
    double progress = remainingTime.inMinutes / totalDuration.inMinutes;
    
    // Ensure progress is between 0 and 1
    return progress.clamp(0.0, 1.0);
  }

  // static String getTimeRemaining(String dateTimeString) {
  //   /*
  //   This Method Calculate the remaining time of booking start time and show up.
  //   - This Service Will Start After 10 days and 6 hours
  //   * */
  //   DateTime serviceDateTime = DateTime.parse(dateTimeString).toLocal();
  //   DateTime now = DateTime.now().toLocal();
  //   Duration difference = serviceDateTime.difference(now);
  //   int days = difference.inDays;
  //   int hours = difference.inHours.remainder(24);
  //
  //   String timeRemaining = "";
  //
  //   if (days > 0) {
  //     timeRemaining = "$days ${DazzifyApp.tr.days} ${DazzifyApp.tr.and} ";
  //   }
  //   if (hours > 0) {
  //     timeRemaining += "$hours ${DazzifyApp.tr.hours}";
  //   }
  //
  //   return timeRemaining.trim();
  // }


  static String getTimeRemaining(String dateTimeString) {
    /*
  This Method Calculate the remaining time of booking start time and show up.
  - This Service Will Start After 10 days and 6 hours
  */
    DateTime serviceDateTime = DateTime.parse(dateTimeString).toLocal();
    DateTime now = DateTime.now().toLocal();
    Duration difference = serviceDateTime.difference(now);
    int days = difference.inDays;
    int hours = difference.inHours.remainder(24);
    // Check if the service time is now
    if (difference.isNegative || difference.inMinutes == 0) {
      return DazzifyApp.tr.inProgress;
    }
    // Return empty string if the service starts in less than 15 minutes or is in the past
    else if (difference.inMinutes < 15) {
      return "";
    }


    String timeRemaining = "";

    if (days > 0) {
      timeRemaining = "$days ${DazzifyApp.tr.days} ${DazzifyApp.tr.and} ";
    }
    if (hours > 0) {
      timeRemaining += "$hours ${DazzifyApp.tr.hours}";
    }

    return timeRemaining.trim();
  }

  static String formatServiceDuration(int totalDurationInMinutes, BuildContext context) {
    if (totalDurationInMinutes >= 60) {
      int hours = totalDurationInMinutes ~/ 60;  // Get the whole number of hours
      int minutes = totalDurationInMinutes % 60;  // Get the remaining minutes

      if (minutes > 0) {
        return "$hours ${context.tr.hours} ${minutes} ${context.tr.min}";  // Display hours and minutes
      } else {
        return "$hours ${context.tr.hours}";  // Display only hours if no remaining minutes
      }
    } else {
      return "$totalDurationInMinutes ${context.tr.min}";  // Display in minutes if less than 60 minutes
    }
  }




}

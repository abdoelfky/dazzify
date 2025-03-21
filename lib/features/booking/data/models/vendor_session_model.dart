import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/time_manager.dart';
import 'package:equatable/equatable.dart';

class VendorSessionModel extends Equatable {
  final String fromTime;
  final String toTime;
  final String fromDate;
  final String toDate;
  final String startTimeStamp;
  final AvailabilityDayTime dayTime;
  final String day;

  const VendorSessionModel({
    required this.fromTime,
    required this.toTime,
    required this.fromDate,
    required this.toDate,
    required this.startTimeStamp,
    required this.dayTime,
    required this.day,
  });

  static VendorSessionModel fromJson(Map<String, dynamic> json) {
    String startTimeStamp = json['startTime'] as String;
    String endTimeStamp = json['endTime'] as String;

    String day = TimeManager.extractDay(startTimeStamp);
    return VendorSessionModel(
      fromTime: TimeManager.to12HFormat(startTimeStamp),
      toTime: TimeManager.to12HFormat(endTimeStamp),
      fromDate: TimeManager.extractDate(startTimeStamp),
      toDate: TimeManager.extractDate(endTimeStamp),
      startTimeStamp: startTimeStamp,
      dayTime: startTimeStamp.toAvailabilityDayTime(),
      day: day,
    );
  }

  const VendorSessionModel.empty([
    this.fromTime = AppConstants.zeroTime,
    this.toTime = AppConstants.zeroTime,
    this.fromDate = '',
    this.toDate = '',
    this.startTimeStamp = '',
    this.dayTime = AvailabilityDayTime.am,
    this.day = '',
  ]);

  @override
  List<Object?> get props => [
        fromTime,
        toTime,
        fromDate,
        toDate,
        startTimeStamp,
        dayTime,
        day,
      ];
}

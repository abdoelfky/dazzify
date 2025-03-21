import 'dart:math' as math;

import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/get_angle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClockCustomPainer extends CustomPainter {
  final String fromTime;
  final String toTime;
  final Color inActiveColor;
  final Color inActiveBorderColor;
  final Color activeBodyColor;
  final Color activeBorderColor;
  final bool isSelected;

  ClockCustomPainer({
    required this.inActiveColor,
    required this.activeBodyColor,
    required this.inActiveBorderColor,
    required this.activeBorderColor,
    required this.fromTime,
    required this.toTime,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /*
      - the comming parameters fromTime andtoTime are in 12H format, 
        example: (12:00 PM).
    */

    /*
    Step1:
        for both fromTime and toTime, remove (am) or (pm), and extract
        the clock and minutes, then convert them to doubles.

        example: (12:30 PM) --> (12:30) as String --> (12)(30)as string
                --> (12)(2)as doubles 
    */
    String fromClock = fromTime.split(' ').first.split(':')[0];
    String toClock = toTime.split(' ').first.split(':')[0];

    double fromClockNumber = double.parse(fromClock);
    double toClockNumber = double.parse(toClock);

    String fromMinutes = fromTime.split(' ').first.split(':')[1];
    String toMinutes = toTime.split(' ').first.split(':')[1];

    double fromMinutesNumber = int.parse(fromMinutes) / 60;
    double toMinutesNumber = int.parse(toMinutes) / 60;

    /*
    Step2:
        for both fromTime and toTime,add clock and minutes to get the 
        complete duration (difference between start and end times).
     */
    late double fromTimeNumber;
    late double toTimeNumber;
    late double hoursDifference;

    if (fromClockNumber == toClockNumber &&
        fromMinutesNumber == toMinutesNumber) {
      fromTimeNumber = fromClockNumber + fromMinutesNumber;
      toTimeNumber = fromTimeNumber + 11.30;
      hoursDifference = toTimeNumber - fromTimeNumber;
    } else if (fromClockNumber > toClockNumber) {
      fromTimeNumber = fromClockNumber + fromMinutesNumber;
      toTimeNumber = toClockNumber + toMinutesNumber;
      hoursDifference = 12 - (fromTimeNumber - toTimeNumber);
    } else {
      fromTimeNumber = fromClockNumber + fromMinutesNumber;
      toTimeNumber = toClockNumber + toMinutesNumber;
      hoursDifference = toTimeNumber - fromTimeNumber;
    }

    /*
    Step3:
        calculating the start angle the magnitude of displacement.
   */
    double singleHour = 30 * (math.pi / 180);
    double startAngle = getAngle(fromTimeNumber);
    double sweepAngle = singleHour * hoursDifference;

    /*
    Step4:
        calculating the clock dimensions.
   */
    double width = size.width;
    double height = size.height;
    Offset center = Offset(width / 2, height / 2);

    /*
    Step5:
        creating session path.
   */
    Path path = Path();
    Rect oval = Rect.fromCenter(
        center: center, width: width * 0.8, height: height * 0.8);
    path.addArc(oval, startAngle, sweepAngle);

    /*
    Step6:
        creating body paint and border paint for active and inactive
        sessions.
   */
    Paint bodyPaint = Paint();
    bodyPaint.color = isSelected ? activeBodyColor : inActiveColor;
    bodyPaint.strokeWidth = 25.w;
    bodyPaint.style = PaintingStyle.stroke;
    bodyPaint.strokeCap = StrokeCap.round;

    Paint borderPaint = Paint();
    borderPaint.color = isSelected ? activeBorderColor : inActiveBorderColor;
    borderPaint.strokeWidth = 30.w;
    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeCap = StrokeCap.round;

    /*
    Step7:
        drawing active and inactice sessions and the shadow
        of the active session.
   */
    //a. sessions
    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, bodyPaint);

    //b.shadow
    if (isSelected) {
      canvas.drawShadow(
        path,
        activeBorderColor.withValues(alpha: 0.5),
        40,
        true,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

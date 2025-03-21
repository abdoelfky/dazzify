import 'dart:async';

import 'package:dazzify/core/framework/export.dart';

class LastActiveBookingProgressBar extends StatefulWidget {
  final String startTime;

  const LastActiveBookingProgressBar({super.key, required this.startTime});

  @override
  State<LastActiveBookingProgressBar> createState() =>
      _LastActiveBookingProgressBarState();
}

class _LastActiveBookingProgressBarState
    extends State<LastActiveBookingProgressBar> {
  late Timer _timer;
  late Duration _totalDuration;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _startTimer();
  }

  void _initializeTimer() {
    DateTime startDateTime = DateTime.parse(widget.startTime).toLocal();
    DateTime endTime = startDateTime.add(const Duration(hours: 12));
    _totalDuration = endTime.difference(startDateTime);
    _remainingTime = endTime.difference(DateTime.now());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _remainingTime = _remainingTime - const Duration(minutes: 1);
        if (_remainingTime.inMinutes <= 0) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DText(
          context.tr.waitingForResponse,
          style: context.textTheme.labelSmall!.copyWith(
            color: context.colorScheme.outlineVariant,
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: 120.w,
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(32).r,
            backgroundColor: context.colorScheme.outline,
            color: context.colorScheme.primary,
            value: TimeManager.calculateProgress(
              remainingTime: _remainingTime,
              totalDuration: _totalDuration,
            ),
            minHeight: 8.h,
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: const EdgeInsets.only(left: 1.5).r,
          child: DText(
            TimeManager.formatDuration(_remainingTime),
            style: context.textTheme.labelSmall!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}

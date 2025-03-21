import 'dart:async';

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';

class OtpTimer extends StatefulWidget {
  final void Function() onResendPress;

  const OtpTimer({super.key, required this.onResendPress});

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  final _interval = const Duration(seconds: 1);
  final int _timerMaxSeconds = 60;
  final ValueNotifier<int> _currentSeconds = ValueNotifier(0);
  Timer? _timer;
  double? height;

  String get timerText =>
      '${((_timerMaxSeconds - _currentSeconds.value) ~/ 60).toString().padLeft(2, '0')}: ${((_timerMaxSeconds - _currentSeconds.value) % 60).toString().padLeft(2, '0')}';

  void startTimeout([int? milliseconds]) {
    var duration = _interval;
    _timer?.cancel();
    _timer = Timer.periodic(duration, (timer) {
      _currentSeconds.value = timer.tick;
      if (timer.tick >= _timerMaxSeconds) {
        timer.cancel();
        _currentSeconds.value = -1;
      }
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: _currentSeconds,
            builder: (context, currentSecondsValue, child) => Visibility(
              visible: currentSecondsValue >= 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    SolarIconsOutline.alarm,
                    size: 20.r,
                  ),
                  SizedBox(width: 5.w),
                  DText(
                    context.tr.resendOtpIn,
                    style: context.textTheme.labelLarge,
                  ),
                  SizedBox(width: 5.h),
                  DText(
                    timerText,
                    style: context.textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _currentSeconds,
            builder: (context, currentSecondsValue, child) => Visibility(
              visible: currentSecondsValue == -1,
              child: CustomFadeAnimation(
                duration: const Duration(milliseconds: 250),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DText(
                      context.tr.noOtpCode,
                      style: context.textTheme.labelLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onResendPress();
                        setState(() {
                          height = 0;
                        });
                        _currentSeconds.value = 0; // Reset the timer value
                        startTimeout(); // Restart the timer
                      },
                      child: DText(
                        context.tr.resendOtp,
                        style: context.textTheme.labelLarge!.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _currentSeconds.dispose();
    super.dispose();
  }
}

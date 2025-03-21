import 'dart:math' as math;

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/presentation/widgets/time_selection_widget/components/analog_clock/get_angle.dart';

class ClockNumbers extends StatelessWidget {
  const ClockNumbers({
    super.key,
    required this.diameter,
  });

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: Stack(
            children: List.generate(
          12,
          (index) {
            double number = index + 1;
            double angle = getAngle(number);
            double x = math.cos(angle) * (diameter);
            double y = math.sin(angle) * (diameter);

            return Align(
              alignment: Alignment(x / diameter, y / diameter),
              child: GestureDetector(
                  child: DText('${number.round()}',
                      style: context.textTheme.labelSmall)),
            );
          },
        )),
      ),
    );
  }
}

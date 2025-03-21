import 'dart:math' as math;

double getAngle(double clockMinutes) {
  double coeffiecient = 0;

  if (clockMinutes <= 2) {
    coeffiecient = clockMinutes + 9;
  } else {
    coeffiecient = clockMinutes - 3;
  }
  return (math.pi / 180) * (30 * coeffiecient);
}

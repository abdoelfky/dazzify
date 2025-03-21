import 'package:flutter/material.dart';

class ServiceClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8718733, size.height * 0.2796047);
    path_0.cubicTo(size.width * 0.9500267, size.height * 0.3342859, size.width,
        size.height * 0.3750781, size.width, size.height * 0.3750781);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width * -0.003697013, size.height);
    path_0.cubicTo(
        size.width * -0.003697013,
        size.height,
        size.width * -0.1303787,
        size.height * 0.3976016,
        size.width * -0.003697013,
        size.height * 0.1389972);
    path_0.cubicTo(
        size.width * 0.002680647,
        size.height * 0.1259781,
        size.width * 0.009639867,
        size.height * 0.1140031,
        size.width * 0.01713807,
        size.height * 0.1030200);
    path_0.cubicTo(
        size.width * 0.1895973,
        size.height * -0.1495939,
        size.width * 0.6471833,
        size.height * 0.1223984,
        size.width * 0.8718733,
        size.height * 0.2796047);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(covariant ServiceClipper oldClipper) {
    return true;
  }
}

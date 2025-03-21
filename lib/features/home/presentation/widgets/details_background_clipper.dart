import 'package:flutter/material.dart';

class DetailsBackgroundClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width, size.height);
    path_0.cubicTo(
        size.width,
        size.height,
        size.width * 0.9062694,
        size.height * 0.8348667,
        size.width * 0.7958333,
        size.height * 0.7724138);
    path_0.cubicTo(
        size.width * 0.6181694,
        size.height * 0.6719402,
        size.width * 0.3322222,
        size.height * 0.8004299,
        size.width * 0.1557986,
        size.height * 0.9012391);
    path_0.cubicTo(size.width * 0.09288972, size.height * 0.9371862, 0,
        size.height * 0.9007494, 0, size.height * 0.8374828);
    path_0.lineTo(0, 0);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant DetailsBackgroundClipper oldClipper) {
    return true;
  }
}

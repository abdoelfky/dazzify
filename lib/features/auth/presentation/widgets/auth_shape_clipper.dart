import 'package:flutter/material.dart';

class AuthShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width, size.height * 0.9876543);
    path_0.cubicTo(
        size.width,
        size.height * 0.9876543,
        size.width * 0.8059694,
        size.height * 0.9115226,
        size.width * 0.6527778,
        size.height * 0.9115226);
    path_0.cubicTo(
        size.width * 0.5263889,
        size.height * 0.9115226,
        size.width * 0.3776556,
        size.height * 0.9702305,
        size.width * 0.2652778,
        size.height * 0.9876543);
    path_0.cubicTo(size.width * 0.1181497, size.height * 1.010469, 0,
        size.height * 0.9876543, 0, size.height * 0.9876543);
    path_0.lineTo(0, 0);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant AuthShapeClipper oldClipper) {
    return true;
  }
}

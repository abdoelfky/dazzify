import 'package:flutter/material.dart';

class HomeCarouselClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.cubicTo(0, 0, size.width * 0.2500000, 0, size.width * 0.5000000, 0);
    path_0.cubicTo(size.width * 0.7500000, 0, size.width, 0, size.width, 0);
    path_0.lineTo(size.width, size.height);
    path_0.cubicTo(
        size.width,
        size.height,
        size.width * 0.6956278,
        size.height * 0.9521739,
        size.width * 0.5000000,
        size.height * 0.9521739);
    path_0.cubicTo(size.width * 0.3043722, size.height * 0.9521739, 0,
        size.height, 0, size.height);
    path_0.lineTo(0, 0);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant HomeCarouselClipper oldClipper) {
    return true;
  }
}

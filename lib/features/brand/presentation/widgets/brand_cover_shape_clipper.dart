import 'package:flutter/material.dart';

class BrandProfileCoverClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.002659574, 0);
    path_0.lineTo(size.width * 0.9978537, 0);
    path_0.lineTo(size.width * 0.9978537, size.height);
    path_0.cubicTo(
        size.width * 0.9978537,
        size.height,
        size.width * 0.5244495,
        size.height * 0.8650190,
        size.width * 0.3143431,
        size.height * 0.6825095);
    path_0.cubicTo(size.width * -0.05001782, size.height * 0.3660061,
        size.width * 0.002659574, 0, size.width * 0.002659574, 0);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant BrandProfileCoverClipper oldClipper) {
    return true;
  }
}

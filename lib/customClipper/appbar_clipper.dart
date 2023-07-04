import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
class AppbarClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(30, size.height);
    path.arcTo(    Rect.fromCenter(
      center: Offset(100, 100),
      height: 110,
      width: 100,
    ),  math.pi,
      math.pi,
      false,);

    path.lineTo(150, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
class OptionClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width*0.81, 0);


    path.arcTo(    Rect.fromCenter(
      center: Offset(size.width*0.46,15),
      height: 95,
      width: 96,
    ),  270,
      math.pi,
      false,);
    path.lineTo(size.width*0.14, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
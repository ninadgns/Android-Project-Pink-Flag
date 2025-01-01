import 'package:flutter/material.dart';

class BigClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 414;
    path.lineTo(-0.003999999999997783 * _xScaling,341.78499999999997 * _yScaling);
    path.cubicTo(-0.003999999999997783 * _xScaling,341.78499999999997 * _yScaling,23.461000000000002 * _xScaling,363.15099999999995 * _yScaling,71.553 * _xScaling,363.15099999999995 * _yScaling,);
    path.cubicTo(119.645 * _xScaling,363.15099999999995 * _yScaling,142.21699999999998 * _xScaling,300.186 * _yScaling,203.29500000000002 * _xScaling,307.21 * _yScaling,);
    path.cubicTo(264.373 * _xScaling,314.234 * _yScaling,282.666 * _xScaling,333.47299999999996 * _yScaling,338.408 * _xScaling,333.47299999999996 * _yScaling,);
    path.cubicTo(394.15000000000003 * _xScaling,333.47299999999996 * _yScaling,413.99600000000004 * _xScaling,254.199 * _yScaling,413.99600000000004 * _xScaling,254.199 * _yScaling,);
    path.cubicTo(413.99600000000004 * _xScaling,254.199 * _yScaling,413.99600000000004 * _xScaling,0 * _yScaling,413.99600000000004 * _xScaling,0 * _yScaling,);
    path.cubicTo(413.99600000000004 * _xScaling,0 * _yScaling,-0.003999999999976467 * _xScaling,0 * _yScaling,-0.003999999999976467 * _xScaling,0 * _yScaling,);
    path.cubicTo(-0.003999999999976467 * _xScaling,0 * _yScaling,-0.003999999999997783 * _xScaling,341.78499999999997 * _yScaling,-0.003999999999997783 * _xScaling,341.78499999999997 * _yScaling,);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip as the path doesn't change
  }
}

class BigClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 370;
    path.lineTo(-0.003999999999997783 * _xScaling,341.78499999999997 * _yScaling);
    path.cubicTo(-0.003999999999997783 * _xScaling,341.78499999999997 * _yScaling,23.461000000000002 * _xScaling,363.15099999999995 * _yScaling,71.553 * _xScaling,363.15099999999995 * _yScaling,);
    path.cubicTo(119.645 * _xScaling,363.15099999999995 * _yScaling,142.21699999999998 * _xScaling,300.186 * _yScaling,203.29500000000002 * _xScaling,307.21 * _yScaling,);
    path.cubicTo(264.373 * _xScaling,314.234 * _yScaling,282.666 * _xScaling,333.47299999999996 * _yScaling,338.408 * _xScaling,333.47299999999996 * _yScaling,);
    path.cubicTo(394.15000000000003 * _xScaling,333.47299999999996 * _yScaling,413.99600000000004 * _xScaling,254.199 * _yScaling,413.99600000000004 * _xScaling,254.199 * _yScaling,);
    path.cubicTo(413.99600000000004 * _xScaling,254.199 * _yScaling,413.99600000000004 * _xScaling,0 * _yScaling,413.99600000000004 * _xScaling,0 * _yScaling,);
    path.cubicTo(413.99600000000004 * _xScaling,0 * _yScaling,-0.003999999999976467 * _xScaling,0 * _yScaling,-0.003999999999976467 * _xScaling,0 * _yScaling,);
    path.cubicTo(-0.003999999999976467 * _xScaling,0 * _yScaling,-0.003999999999997783 * _xScaling,341.78499999999997 * _yScaling,-0.003999999999997783 * _xScaling,341.78499999999997 * _yScaling,);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip as the path doesn't change
  }
}

class SmallClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 350;
    path.lineTo(-0.003999999999997783 * _xScaling,217.841 * _yScaling);
    path.cubicTo(-0.003999999999997783 * _xScaling,217.841 * _yScaling,19.14 * _xScaling,265.91999999999996 * _yScaling,67.233 * _xScaling,265.91999999999996 * _yScaling,);
    path.cubicTo(115.326 * _xScaling,265.91999999999996 * _yScaling,112.752 * _xScaling,234.611 * _yScaling,173.83299999999997 * _xScaling,241.635 * _yScaling,);
    path.cubicTo(234.914 * _xScaling,248.659 * _yScaling,272.866 * _xScaling,301.691 * _yScaling,328.608 * _xScaling,301.691 * _yScaling,);
    path.cubicTo(384.34999999999997 * _xScaling,301.691 * _yScaling,413.99600000000004 * _xScaling,201.977 * _yScaling,413.99600000000004 * _xScaling,201.977 * _yScaling,);
    path.cubicTo(413.99600000000004 * _xScaling,201.977 * _yScaling,413.99600000000004 * _xScaling,0 * _yScaling,413.99600000000004 * _xScaling,0 * _yScaling,);
    path.cubicTo(413.99600000000004 * _xScaling,0 * _yScaling,-0.003999999999976467 * _xScaling,0 * _yScaling,-0.003999999999976467 * _xScaling,0 * _yScaling,);
    path.cubicTo(-0.003999999999976467 * _xScaling,0 * _yScaling,-0.003999999999997783 * _xScaling,217.841 * _yScaling,-0.003999999999997783 * _xScaling,217.841 * _yScaling,);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip as the path doesn't change
  }
}

class SmallClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 414;
    final double _yScaling = size.height / 350;
    path.lineTo(-0.003999999999997783 * _xScaling,217.841 * _yScaling);
    path.cubicTo(-0.003999999999997783 * _xScaling,217.841 * _yScaling,19.14 * _xScaling,265.91999999999996 * _yScaling,67.233 * _xScaling,265.91999999999996 * _yScaling,);
    path.cubicTo(115.326 * _xScaling,265.91999999999996 * _yScaling,112.752 * _xScaling,234.611 * _yScaling,173.83299999999997 * _xScaling,241.635 * _yScaling,);
    path.cubicTo(234.914 * _xScaling,248.659 * _yScaling,272.866 * _xScaling,301.691 * _yScaling,328.608 * _xScaling,301.691 * _yScaling,);
    path.cubicTo(384.34999999999997 * _xScaling,301.691 * _yScaling,413.99600000000004 * _xScaling,201.977 * _yScaling,413.99600000000004 * _xScaling,201.977 * _yScaling,);
    path.cubicTo(413.99600000000004 * _xScaling,201.977 * _yScaling,413.99600000000004 * _xScaling,0 * _yScaling,413.99600000000004 * _xScaling,0 * _yScaling,);
    path.cubicTo(413.99600000000004 * _xScaling,0 * _yScaling,-0.003999999999976467 * _xScaling,0 * _yScaling,-0.003999999999976467 * _xScaling,0 * _yScaling,);
    path.cubicTo(-0.003999999999976467 * _xScaling,0 * _yScaling,-0.003999999999997783 * _xScaling,217.841 * _yScaling,-0.003999999999997783 * _xScaling,217.841 * _yScaling,);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip as the path doesn't change
  }
}
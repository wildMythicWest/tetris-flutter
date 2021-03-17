import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tetris/shape.dart';

class NextShapePainter extends CustomPainter {
  Shape shape;

  NextShapePainter(this.shape);

  @override
  void paint(Canvas canvas, Size size) {
    if(shape == null) return;
    shape.points.forEach((element) {
      element.draw(canvas, 15);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

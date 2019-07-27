import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {

  final double width;
  final double radius;
  final Color color;

  RadarPainter({ 
    this.width = 3,
    this.radius, 
    this.color = const Color.fromRGBO(70, 70, 70, 1.0) 
  });

  @override
  void paint(Canvas canvas, Size size) {
    final circle = Paint()
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..color = color;

    final line = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = color;

    final center = Offset(size.width * .5, size.height * .5);
    canvas.drawCircle(center, radius, circle);

    canvas.drawLine(
      Offset(center.dx, center.dy - radius), 
      Offset(center.dx, center.dy + radius), 
      line
    );

    canvas.drawLine(
      Offset(center.dx - radius, center.dy), 
      Offset(center.dx + radius, center.dy), 
      line
    );
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(RadarPainter oldDelegate) => false;
}
import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  RadarPainter({
    required this.radius,
    this.width = 3,
    this.color = const Color.fromRGBO(70, 70, 70, 1.0),
  });

  final double radius;
  final double width;
  final Color color;

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
    canvas
      ..drawCircle(center, radius, circle)
      ..drawLine(Offset(center.dx, center.dy - radius),
          Offset(center.dx, center.dy + radius), line)
      ..drawLine(Offset(center.dx - radius, center.dy),
          Offset(center.dx + radius, center.dy), line);
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(covariant RadarPainter oldDelegate) => false;
}

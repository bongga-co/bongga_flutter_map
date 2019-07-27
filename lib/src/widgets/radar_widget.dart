import 'package:flutter/material.dart';
import 'package:bongga_flutter_map/src/canvas/radar_canvas.dart';

class Radar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double appBarHeight = AppBar().preferredSize.height;
    final double boxSize = 40.0;

    return Positioned(
      top: (size.height * 0.5) - appBarHeight - 6.0,
      left: (size.width * 0.5) - (boxSize * 0.5),
      child: Container(
        height: boxSize,
        width: boxSize,
        child: CustomPaint(
          painter: RadarPainter(radius: boxSize * .5),
        ),
      ),
    );
  }
}
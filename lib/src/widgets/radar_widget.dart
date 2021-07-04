import 'package:flutter/material.dart';
import 'package:bongga_flutter_map/src/canvas/radar_canvas.dart';

class Radar extends StatelessWidget {
  const Radar({Key? key}) : super(key: key);

  static const _boxSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appBarHeight = AppBar().preferredSize.height;

    return Positioned(
      top: (size.height * 0.5) - appBarHeight - 6.0,
      left: (size.width * 0.5) - (_boxSize * 0.5),
      child: SizedBox(
        height: _boxSize,
        width: _boxSize,
        child: CustomPaint(
          painter: RadarPainter(radius: _boxSize * .5),
        ),
      ),
    );
  }
}

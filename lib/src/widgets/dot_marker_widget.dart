import 'package:flutter/material.dart';

class DotMarker extends StatelessWidget {
  const DotMarker({
    super.key,
    this.color = Colors.blue,
    this.size = 10,
    this.borderWidth = 1,
  });

  final Color color;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: color,
        border: Border.all(color: Colors.white, width: borderWidth),
      ),
    );
  }
}

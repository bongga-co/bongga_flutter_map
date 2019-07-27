import 'package:flutter/material.dart';

class DotMarker extends StatelessWidget {

  final Color color;
  final double size;

  DotMarker({ 
    this.color = Colors.orange, 
    this.size = 30.0,
    Key key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: color,
        border: Border.all(color: Colors.white, width: 5.0),
      ),
    );
  }
}
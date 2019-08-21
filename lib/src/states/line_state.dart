import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class LineState {

  LineState({ @required this.notify }) : assert(notify != null);

  final Function notify;
  final Map<String, Polyline> _namedLines = {};

  List<Polyline> get lines => _namedLines.values.toList();

  Future<void> addLine({
    @required String name,
    @required List<LatLng> points,
    double width = 1.0,
    Color color = Colors.green,
    bool isDotted = false
  }) async {
    
    _namedLines[name] = Polyline(
      points: points,
      strokeWidth: width, 
      color: color, 
      isDotted: isDotted
    );
    
    notify("updateLines", _namedLines[name], addLine);
  }
}

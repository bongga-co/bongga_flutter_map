import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

/// State of the polygons on the map
class PolygonState {
  PolygonState({ @required this.notify }) : assert(notify != null);

  final Function notify;
  final Map<String, Polygon> _namedPolygons = {};

  List<Polygon> get polygons => _namedPolygons.values.toList();

  /// Add a polygon on the map
  Future<void> addPolygon({
    @required String name,
    @required List<LatLng> points,
    Color color,
    double borderWidth,
    Color borderColor
  }) async {
    
    _namedPolygons[name] = Polygon(
    points: points,
    color: color,
    borderStrokeWidth: borderWidth,
    borderColor: borderColor);

    notify("updatePolygons", _namedPolygons[name], addPolygon);
  }
}
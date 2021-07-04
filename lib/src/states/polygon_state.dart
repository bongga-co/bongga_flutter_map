import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

/// State of the polygons on the map
class PolygonState {
  PolygonState({required this.mapController, required this.notify});

  final MapController mapController;
  final Function notify;

  final Map<String, Polygon> _namedPolygons = {};

  var _polygons = <Polygon>[];

  List<Polygon> get polygons => _polygons;

  Map<String, Polygon> get namedPolygons => _namedPolygons;

  /// Add a polygon on the map
  Future<void> addPolygon({
    required String name,
    required List<LatLng> points,
    Color color = Colors.purple,
    double borderWidth = 1.0,
    Color borderColor = Colors.deepPurple,
  }) async {
    try {
      _namedPolygons[name] = Polygon(
        points: points,
        color: color,
        borderStrokeWidth: borderWidth,
        borderColor: borderColor,
      );
    } catch (e) {
      throw Exception('Can not add polygon: $e');
    }

    try {
      _buildPolygons();
    } catch (e) {
      throw Exception('Can not build for add polygon: $e');
    }

    notify('updatePolygons', _namedPolygons[name], addPolygon);
  }

  /// Remove a polygon from the map
  Future<void> removePolygon({required String name}) async {
    try {
      final res = _namedPolygons.remove(name);

      if (res == null) {
        throw Exception('Polygon $name not found in map');
      }
    } catch (e) {
      // throw ("Can not remove the polygon: $e");
    }

    try {
      _buildPolygons();
    } catch (e) {
      throw Exception('Can not build for remove polygon: $e');
    }

    notify('updatePolygons', _polygons, removePolygon);
  }

  /// Add multiple polygons on the map
  Future<void> addPolygons({required Map<String, Polygon> polygons}) async {
    try {
      polygons.forEach((k, v) => _namedPolygons[k] = v);
    } catch (e) {
      throw Exception('Can not add polygon: $e');
    }
    _buildPolygons();
    notify('updatePolygons', _polygons, addPolygons);
  }

  /// Remove multiple polygons from the map
  Future<void> removePolygons({required List<String> names}) async {
    names.forEach(_namedPolygons.remove);
    _buildPolygons();
    notify('updatePolygons', _polygons, removePolygons);
  }

  void _buildPolygons() {
    var listPolygons = <Polygon>[];
    for (var k in _namedPolygons.keys) {
      listPolygons.add(_namedPolygons[k]!);
    }
    _polygons = listPolygons;
  }
}

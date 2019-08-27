import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class LineState {

  LineState({ 
    @required this.mapController,
    @required this.notify 
  }) : 
  assert(notify != null),
  assert(mapController != null);

  final MapController mapController;
  final Function notify;
  final Map<String, Polyline> _namedLines = {};

  var _lines = <Polyline>[];

  List<Polyline> get lines => _lines;
  Map<String, Polyline> get namedLines => _namedLines;

  Future<void> addLine({
    @required String name,
    @required List<LatLng> points,
    double width = 1.0,
    Color color = Colors.orange,
    bool isDotted = false
  }) async {

    if (points == null) throw ArgumentError("points must not be null");
    if (name == null) throw ArgumentError("name must not be null");

    try {
      _namedLines[name] = Polyline(
        points: points,
        strokeWidth: width, 
        color: color, 
        isDotted: isDotted
      );
    } catch (e) {
      throw ("Can not add line: $e");
    }

    try {
      _buildLines();
    } catch (e) {
      throw ("Can not build for add line: $e");
    }
    
    notify("updateLines", _namedLines[name], addLine);
  }

  /// Remove a line from the map
  Future<void> removeLine({ @required String name }) async {
    if (name == null) throw ArgumentError("name must not be null");
    
    try {
      final res = _namedLines.remove(name);

      if (res == null) {
        throw ("Line $name not found in map");
      }
    } catch (e) {
      //throw ("Can not remove the line: $e");
    }

    try {
      _buildLines();
    } catch (e) {
      throw ("Can not build for remove line: $e");
    }
    
    notify("updateLines", lines, removeLine);
  }

  /// Add multiple lines on the map
  Future<void> addLines({ @required Map<String, Polyline> lines }) async {
    if (lines == null) {
      throw (ArgumentError.notNull("lines must not be null"));
    }

    if (lines == null) throw ArgumentError("lines must not be null");

    try {
      lines.forEach((k, v) {
        _namedLines[k] = v;
      });
    } catch (e) {
      throw ("Can not add lines: $e");
    }
    _buildLines();
    notify("updateLines", _lines, addLines);
  }

  /// Remove multiple lines from the map
  Future<void> removeLines({ @required List<String> names }) async {
    if (names == null) throw (ArgumentError.notNull("names must not be null"));

    names.forEach((name) {
      _namedLines.remove(name);
    });

    _buildLines();
    notify("updateLines", _lines, removeLines);
  }

  void _buildLines() {
    var listLines = <Polyline>[];
    
    for (var k in _namedLines.keys) {
      listLines.add(_namedLines[k]);
    }

    _lines = listLines;
  }
}

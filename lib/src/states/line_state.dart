import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LineState {
  LineState({required this.mapController, required this.notify});

  final MapController mapController;
  final Function notify;

  final Map<String, Polyline> _namedLines = {};

  var _lines = <Polyline>[];

  List<Polyline> get lines => _lines;

  Map<String, Polyline> get namedLines => _namedLines;

  Future<void> addLine({
    required String name,
    required List<LatLng> points,
    double width = 1,
    Color color = Colors.orange,
    bool isDotted = false,
  }) async {
    try {
      _namedLines[name] = Polyline(
        points: points,
        strokeWidth: width,
        color: color,
        isDotted: isDotted,
      );
    } catch (e) {
      throw Exception('Can not add line: $e');
    }

    try {
      _buildLines();
    } catch (e) {
      throw Exception('Can not build for add line: $e');
    }

    notify('updateLines', _namedLines[name], addLine);
  }

  /// Remove a line from the map
  Future<void> removeLine({required String name}) async {
    try {
      final res = _namedLines.remove(name);

      if (res == null) {
        throw Exception('Line $name not found in map');
      }
    } catch (e) {
      //throw ("Can not remove the line: $e");
    }

    try {
      _buildLines();
    } catch (e) {
      throw Exception('Can not build for remove line: $e');
    }

    notify('updateLines', lines, removeLine);
  }

  /// Add multiple lines on the map
  Future<void> addLines({required Map<String, Polyline> lines}) async {
    try {
      lines.forEach((k, v) => _namedLines[k] = v);
    } catch (e) {
      throw Exception('Can not add lines: $e');
    }

    _buildLines();
    notify('updateLines', _lines, addLines);
  }

  /// Remove multiple lines from the map
  Future<void> removeLines({required List<String> names}) async {
    names.forEach(_namedLines.remove);
    _buildLines();

    notify('updateLines', _lines, removeLines);
  }

  void _buildLines() {
    final listLines = <Polyline>[];
    for (final k in _namedLines.keys) {
      listLines.add(_namedLines[k]!);
    }
    _lines = listLines;
  }
}

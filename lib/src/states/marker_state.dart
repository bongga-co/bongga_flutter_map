import 'package:flutter_map/flutter_map.dart';
import 'package:bongga_flutter_map/bongga_flutter_map.dart';

class MarkerState {
  MarkerState({required this.mapController, required this.notify});

  final MapController mapController;
  final Function notify;

  final Map<String, Marker> _namedMarkers = {};

  var _markers = <Marker>[];

  List<Marker> get markers => _markers;

  Map<String, Marker> get namedMarkers => _namedMarkers;

  Future<void> addMarker({required Marker marker, required String name}) async {
    try {
      _namedMarkers[name] = marker;
    } catch (e) {
      throw Exception('Can not add marker: $e');
    }

    try {
      _buildMarkers();
    } catch (e) {
      throw Exception('Can not build for add marker: $e');
    }

    notify('updateMarkers', _markers, addMarker);
  }

  /// Remove a marker from the map
  Future<void> removeMarker({required String name}) async {
    try {
      final res = _namedMarkers.remove(name);
      if (res == null) {
        throw Exception('Marker $name not found in map');
      }
    } catch (e) {
      //throw ("Can not remove marker: $e");
    }

    try {
      _buildMarkers();
    } catch (e) {
      throw Exception('Can not build for remove marker: $e');
    }

    notify('updateMarkers', _markers, removeMarker);
  }

  /// Add multiple markers on the map
  Future<void> addMarkers({required Map<String, Marker> markers}) async {
    try {
      markers.forEach((k, v) => _namedMarkers[k] = v);
    } catch (e) {
      throw Exception('Can not add markers: $e');
    }

    _buildMarkers();
    notify('updateMarkers', _markers, addMarkers);
  }

  /// Remove multiple markers from the map
  Future<void> removeMarkers({required List<String> names}) async {
    names.forEach(_namedMarkers.remove);
    _buildMarkers();

    notify('updateMarkers', _markers, removeMarkers);
  }

  /// Remove a marker from the map
  Future<void> updateMarker({
    required String name,
    required LatLng position,
  }) async {
    try {
      _namedMarkers[name] = Marker(
        builder: _namedMarkers[name]!.builder,
        height: _namedMarkers[name]!.height,
        width: _namedMarkers[name]!.width,
        point: position,
      );

      // if (res == null) {
      //   throw ("Marker $name not found in map");
      // }
    } catch (e) {
      //throw ("Can not remove marker: $e");
    }

    try {
      _buildMarkers();
    } catch (e) {
      throw Exception('Can not build for remove marker: $e');
    }

    notify('updateMarkers', _markers, updateMarker);
  }

  void _buildMarkers() {
    var listMarkers = <Marker>[];

    for (var k in _namedMarkers.keys) {
      listMarkers.add(_namedMarkers[k]!);
    }

    _markers = listMarkers;
  }
}

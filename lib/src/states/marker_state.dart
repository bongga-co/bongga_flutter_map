import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:bongga_flutter_map/bongga_flutter_map.dart';

class MarkerState {

  MarkerState({
    @required this.mapController, 
    @required this.notify
  }) : 
  assert(notify != null),
  assert(mapController != null);

  final MapController mapController;
  final Function notify;
  final Map<String, Marker> _namedMarkers = {};

  var _markers = <Marker>[];
  
  List<Marker> get markers => _markers;
  Map<String, Marker> get namedMarkers => _namedMarkers;

  Future<void> addMarker({
    @required Marker marker, 
    @required String name 
  }) async {
    if (marker == null) throw ArgumentError("marker must not be null");
    if (name == null) throw ArgumentError("name must not be null");
    
    try {
      _namedMarkers[name] = marker;
    } catch (e) {
      throw ("Can not add marker: $e");
    }
    
    try {
      _buildMarkers();
    } catch (e) {
      throw ("Can not build for add marker: $e");
    }
    
    notify("updateMarkers", _markers, addMarker);
  }

  /// Remove a marker from the map
  Future<void> removeMarker({ @required String name }) async {
    if (name == null) throw ArgumentError("name must not be null");
    
    try {
      final res = _namedMarkers.remove(name);

      if (res == null) {
        throw ("Marker $name not found in map");
      }
    } catch (e) {
      //throw ("Can not remove marker: $e");
    }

    try {
      _buildMarkers();
    } catch (e) {
      throw ("Can not build for remove marker: $e");
    }
    
    notify("updateMarkers", _markers, removeMarker);
  }

  /// Add multiple markers on the map
  Future<void> addMarkers({ @required Map<String, Marker> markers }) async {
    if (markers == null) {
      throw (ArgumentError.notNull("markers must not be null"));
    }

    if (markers == null) throw ArgumentError("markers must not be null");

    try {
      markers.forEach((k, v) {
        _namedMarkers[k] = v;
      });
    } catch (e) {
      throw ("Can not add markers: $e");
    }
    _buildMarkers();
    notify("updateMarkers", _markers, addMarkers);
  }

  /// Remove multiple markers from the map
  Future<void> removeMarkers({ @required List<String> names }) async {
    if (names == null) throw (ArgumentError.notNull("names must not be null"));

    names.forEach((name) {
      _namedMarkers.remove(name);
    });

    _buildMarkers();
    notify("updateMarkers", _markers, removeMarkers);
  }

  /// Remove a marker from the map
  Future<void> updateMarker({ 
    @required String name, 
    @required LatLng position 
  }) async {
    if (name == null) throw ArgumentError("name must not be null");
    
    try {
      final res = _namedMarkers[name] = Marker(
        builder: _namedMarkers[name].builder,
        height: _namedMarkers[name].height,
        width: _namedMarkers[name].width,
        point: position        
      );

      if (res == null) {
        throw ("Marker $name not found in map");
      }
    } catch (e) {
      //throw ("Can not remove marker: $e");
    }

    try {
      _buildMarkers();
    } catch (e) {
      throw ("Can not build for remove marker: $e");
    }
    
    notify("updateMarkers", _markers, updateMarker);
  }

  void _buildMarkers() {
    var listMarkers = <Marker>[];
    
    for (var k in _namedMarkers.keys) {
      listMarkers.add(_namedMarkers[k]);
    }

    _markers = listMarkers;
  }
}
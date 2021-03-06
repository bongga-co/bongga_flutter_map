import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:bongga_flutter_map/src/states/marker_state.dart';

class MapState {

  final MapController mapController;
  final Function notify;

  MarkerState markerState;
  double _zoom = 1.0;
  LatLng _center = LatLng(0.0, 0.0);

  MapState({
    @required this.mapController,
    @required this.notify,
    @required this.markerState
  }) : assert(mapController != null);

  /// Zoom in one level
  Future<void> zoomIn() async {
    double z = mapController.zoom + 1;
    mapController.move(mapController.center, z);
    _zoom = z;

    notify("zoom", z, zoomIn);
  }

  /// Zoom out one level
  Future<void> zoomOut() async {
    double z = mapController.zoom - 1;
    mapController.move(mapController.center, z);
    _zoom = z;

    notify("zoom", z, zoomOut);
  }

  /// Zoom to level
  Future<void> zoomTo(double value) async {
    mapController.move(mapController.center, value);
    _zoom = value;

    notify("zoom", value, zoomOut);
  }

  /// Center the map on a [LatLng]
  Future<void> centerOnPoint(LatLng point) async {
    mapController.move(point, mapController.zoom);
    _center = point;

    notify("center", point, centerOnPoint);
  }

  /// This is used to handle the gestures
  void onPositionChanged(MapPosition posChange, bool gesture) {
    if (posChange.zoom != _zoom) {
      _zoom = posChange.zoom;

      notify("zoom", posChange.zoom, onPositionChanged);
    }

    if (posChange.center != _center) {
      _center = posChange.center;

      notify("center", posChange.center, onPositionChanged);
    }
  }
}

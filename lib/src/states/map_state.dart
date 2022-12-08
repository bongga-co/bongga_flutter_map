import 'package:bongga_flutter_map/src/states/marker_state.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapState {
  MapState({
    required this.mapController,
    required this.notify,
    required this.markerState,
  });

  final MapController mapController;
  final Function notify;
  final MarkerState markerState;

  double _zoom = 1;
  LatLng _center = LatLng(0, 0);

  /// Zoom in one level
  Future<void> zoomIn() async {
    final z = mapController.zoom + 1;

    mapController.move(mapController.center, z);
    _zoom = z;

    notify('zoom', z, zoomIn);
  }

  /// Zoom out one level
  Future<void> zoomOut() async {
    final z = mapController.zoom - 1;

    mapController.move(mapController.center, z);
    _zoom = z;

    notify('zoom', z, zoomOut);
  }

  /// Zoom to level
  Future<void> zoomTo(double value) async {
    mapController.move(mapController.center, value);
    _zoom = value;

    notify('zoom', value, zoomOut);
  }

  /// Center the map on a [LatLng]
  Future<void> centerOnPoint(LatLng point) async {
    mapController.move(point, mapController.zoom);
    _center = point;

    notify('center', point, centerOnPoint);
  }

  /// This is used to handle the gestures
  void onPositionChanged(MapPosition posChange, {bool gesture = false}) {
    if (posChange.zoom != null && posChange.zoom != _zoom) {
      _zoom = posChange.zoom!;
      notify('zoom', posChange.zoom, onPositionChanged);
    }

    if (posChange.center != null && posChange.center != _center) {
      _center = posChange.center!;
      notify('center', posChange.center, onPositionChanged);
    }
  }
}

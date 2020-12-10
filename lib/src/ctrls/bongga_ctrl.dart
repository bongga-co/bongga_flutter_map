import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:bongga_flutter_map/src/utils/position_util.dart';
import 'package:bongga_flutter_map/src/widgets/dot_marker_widget.dart';
import 'package:bongga_flutter_map/src/models/main_ctrl_model.dart';
import 'package:bongga_flutter_map/src/ctrls/main_ctrl.dart';

class Controller extends MainController {
  final Completer<Null> _completer = Completer<Null>();
  final _subject = rx.PublishSubject<MainControllerChange>();

  bool locationUpdates;
  bool autoCenter = false;
  LatLngBounds bounds;

  LatLng _userLocation;
  Stream<Position> _positionStream;
  StreamSubscription<Position> _positionSubs;
  bool _mapReady = false;
  Marker _marker = Marker(
      width: 10.0,
      height: 10.0,
      point: LatLng(0.0, 0.0),
      builder: _buildMarker);

  Controller(
      {@required this.mapCtrl, @required this.bounds, this.locationUpdates})
      : assert(mapCtrl != null),
        assert(bounds != null),
        super(mapCtrl: mapCtrl) {
    locationUpdates = locationUpdates ?? true;

    if (locationUpdates) {
      _getPositionStream(null);
    }

    onReady.then((_) {
      PositionUtil.getLocation().then((position) {
        updateMarkerFromPosition(position: position);
      });

      if (locationUpdates) {
        _subscribeToPositionStream();
      }

      if (!_completer.isCompleted) {
        _completer.complete();

        _mapReady = true;
      }
    });
  }

  @override
  MapController mapCtrl;

  bool get mapReady => _mapReady;

  LatLng get userLocation => _userLocation;

  /// Custom marker
  static Widget _buildMarker(BuildContext _) => DotMarker();

  void _getPositionStream(Stream<Position> stream) async {
    _positionStream = stream ?? PositionUtil.getPositionStream();
  }

  /// Enable or disable autocenter
  Future<void> toggleAutoCenter() async {
    autoCenter = !autoCenter;
    if (autoCenter) centerMarker();

    notify("toggleAutoCenter", autoCenter, toggleAutoCenter);
  }

  /// Updates the marker on the map from a position
  Future<void> updateMarkerFromPosition({@required Position position}) async {
    if (position == null) return;

    LatLng point = LatLng(position.latitude, position.longitude);
    _userLocation = point;

    try {
      await removeMarker(name: "marker");
    } catch (e) {}

    final marker =
        Marker(width: 10.0, height: 10.0, point: point, builder: _buildMarker);

    _marker = marker;

    if (bounds != null && bounds.contains(point)) {
      await addMarker(marker: _marker, name: "marker");
    }
  }

  /// Center the map on the marker
  Future<void> centerMarker() async {
    mapCtrl.move(_marker.point, mapCtrl.zoom);
  }

  /// Center the map on a [Position]
  Future<void> centerOnPosition(Position position) async {
    LatLng _newCenter = LatLng(position.latitude, position.longitude);

    mapCtrl.move(_newCenter, mapCtrl.zoom);
    centerOnPoint(_newCenter);

    notify("center", _newCenter, centerOnPosition);
  }

  /// Toggle live position stream updates
  void togglePositionStreamSubscription({Stream<Position> stream}) async {
    locationUpdates = !locationUpdates;

    if (!locationUpdates) {
      _positionSubs?.cancel();
    } else {
      _getPositionStream(stream);
      _subscribeToPositionStream();
    }

    notify("positionStream", locationUpdates, togglePositionStreamSubscription);
  }

  void _subscribeToPositionStream() {
    if (_positionStream != null) {
      _positionSubs = _positionStream.listen((Position position) {
        _positionStreamCallbackAction(position);
      });
    }
  }

  /// Process the position stream position
  void _positionStreamCallbackAction(Position position) {
    updateMarkerFromPosition(position: position);

    if (autoCenter) centerOnPosition(position);

    notify("currentPosition", LatLng(position.latitude, position.longitude),
        _positionStreamCallbackAction);
  }

  /// Dispose the position stream subscription
  void dispose() {
    _subject?.close();
    _positionSubs?.cancel();
  }
}

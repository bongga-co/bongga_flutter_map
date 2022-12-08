import 'dart:async';

import 'package:bongga_flutter_map/src/ctrls/main_ctrl.dart';
import 'package:bongga_flutter_map/src/models/main_ctrl_model.dart';
import 'package:bongga_flutter_map/src/utils/position_util.dart';
import 'package:bongga_flutter_map/src/widgets/dot_marker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart' as rx;

class Controller extends MainController {
  Controller({
    required super.mapCtrl,
    required this.bounds,
    this.locationUpdates,
  }) {
    locationUpdates = locationUpdates ?? true;

    if (locationUpdates!) {
      _getPositionStream(null);
    }

    onReady.then((_) {
      PositionUtil.getLocation().then((position) {
        updateMarkerFromPosition(position: position);
      });

      if (locationUpdates!) {
        _subscribeToPositionStream();
      }

      if (!_completer.isCompleted) {
        _completer.complete();
        _mapReady = true;
      }
    });
  }

  bool? locationUpdates;
  final LatLngBounds bounds;

  final Completer<Null> _completer = Completer<Null>();
  final _subject = rx.PublishSubject<MainControllerChange>();

  late LatLng _userLocation;
  late Stream<Position>? _positionStream;
  late StreamSubscription<Position>? _positionSubs;

  bool _autoCenter = false;
  bool _mapReady = false;

  Marker _marker = Marker(
    width: 10,
    height: 10,
    point: LatLng(0, 0),
    builder: _buildMarker,
  );

  bool get mapReady => _mapReady;

  LatLng get userLocation => _userLocation;

  /// Custom marker
  static Widget _buildMarker(BuildContext _) => const DotMarker();

  Future<void> _getPositionStream(Stream<Position>? stream) async {
    _positionStream = stream ?? PositionUtil.getPositionStream();
  }

  /// Enable or disable autocenter
  Future<void> toggleAutoCenter() async {
    _autoCenter = !_autoCenter;
    if (_autoCenter) await centerMarker();

    notify('toggleAutoCenter', _autoCenter, toggleAutoCenter);
  }

  /// Updates the marker on the map from a position
  Future<void> updateMarkerFromPosition({required Position? position}) async {
    if (position == null) return;

    final point = LatLng(position.latitude, position.longitude);
    _userLocation = point;

    try {
      await removeMarker(name: 'marker');
    } catch (e) {
      print(e);
    }

    final marker = Marker(
      width: 10,
      height: 10,
      point: point,
      builder: _buildMarker,
    );

    _marker = marker;

    if (bounds.contains(point)) {
      await addMarker(marker: _marker, name: 'marker');
    }
  }

  /// Center the map on the marker
  Future<void> centerMarker() async {
    mapCtrl.move(_marker.point, mapCtrl.zoom);
  }

  /// Center the map on a [Position]
  Future<void> centerOnPosition(Position position) async {
    final newCenter = LatLng(position.latitude, position.longitude);

    mapCtrl.move(newCenter, mapCtrl.zoom);
    await centerOnPoint(newCenter);

    notify('center', newCenter, centerOnPosition);
  }

  /// Toggle live position stream updates
  Future<void> togglePositionStreamSubscription({
    Stream<Position>? stream,
  }) async {
    locationUpdates = !locationUpdates!;

    if (!locationUpdates!) {
      await _positionSubs?.cancel();
    } else {
      await _getPositionStream(stream);
      _subscribeToPositionStream();
    }

    notify('positionStream', locationUpdates, togglePositionStreamSubscription);
  }

  void _subscribeToPositionStream() {
    if (_positionStream != null) {
      _positionSubs = _positionStream!.listen(_positionStreamCallbackAction);
    }
  }

  /// Process the position stream position
  void _positionStreamCallbackAction(Position position) {
    updateMarkerFromPosition(position: position);
    if (_autoCenter) centerOnPosition(position);

    notify(
      'currentPosition',
      LatLng(position.latitude, position.longitude),
      _positionStreamCallbackAction,
    );
  }

  /// Dispose the position stream subscription
  void dispose() {
    _subject.close();
    _positionSubs?.cancel();
  }
}

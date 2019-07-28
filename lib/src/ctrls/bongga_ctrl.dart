import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bongga_flutter_map/src/utils/position_util.dart';
import 'package:bongga_flutter_map/src/widgets/dot_marker_widget.dart';
import 'package:bongga_flutter_map/src/models/main_ctrl_model.dart';
import 'package:bongga_flutter_map/src/ctrls/main_ctrl.dart';

class Controller extends MainController {

  final Completer<Null> _completer = Completer<Null>();
  final _subject = PublishSubject<MainControllerChange>();

  /// The Geolocator position stream
  Stream<Position> positionStream;

  /// Enable or not the position stream
  bool positionStreamEnabled;

  StreamSubscription<Position> _positionSubs;
  bool autoCenter = false;
  bool _mapReady = false;

  Marker _marker = Marker(
    point: LatLng(0.0, 0.0),
    builder: _buildMarker
  );
  
  Controller({
    @required this.mapCtrl,
    this.positionStream,
    this.positionStreamEnabled
  }) : assert(mapCtrl != null), super(mapCtrl: mapCtrl) {

    positionStreamEnabled = positionStreamEnabled ?? true;

    if (positionStreamEnabled) {
      _getPositionStream(positionStream);
    }
      
    onReady.then((_) {
      if (positionStreamEnabled) _subscribeToPositionStream();

      PositionUtil.getLocation().then((position) {
        updateMarkerFromPosition(position: position);
      });
      
      if (!_completer.isCompleted) {
        _completer.complete();

        _mapReady = true;
      }
    });
  }

  @override
  MapController mapCtrl;

  bool get mapReady => _mapReady;

  /// Custom marker
  static Widget _buildMarker(BuildContext _) => DotMarker();

  void _getPositionStream(Stream<Position> newStream) async {
    PositionUtil.getPositionUpdates().then((stream) {
      positionStream = newStream ?? stream;
    });
  }

  /// Enable or disable autocenter
  Future<void> toggleAutoCenter() async {
    autoCenter = !autoCenter;
    if (autoCenter) centerMarker();
    
    notify("toggleAutoCenter", autoCenter, toggleAutoCenter);
  }

  /// Updates the marker on the map from a position
  Future<void> updateMarkerFromPosition({ @required Position position }) async {

    if (position == null) return;
  
    LatLng point = LatLng(position.latitude, position.longitude);

    try {
      await removeMarker(name: "marker");
    } catch (e) {
      
    }

    final marker = Marker(point: point, builder: _buildMarker);
    _marker = marker;

    await addMarker(marker: _marker, name: "marker");
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
  void togglePositionStreamSubscription({ Stream<Position> stream }) async {

    positionStreamEnabled = !positionStreamEnabled;
    
    if (!positionStreamEnabled) {
      _positionSubs?.cancel();
    } else {
      _getPositionStream(stream);
      _subscribeToPositionStream();
    }

    notify(
      "positionStream", 
      positionStreamEnabled,
      togglePositionStreamSubscription
    );
  }


  void _subscribeToPositionStream() {
    if(positionStream != null) {
      _positionSubs = positionStream.listen((Position position) {
        _positionStreamCallbackAction(position);
      });
    }
  }

  /// Process the position stream position
  void _positionStreamCallbackAction(Position position) {
    updateMarkerFromPosition(position: position);

    if (autoCenter) centerOnPosition(position);

    notify(
      "currentPosition",
      LatLng(position.latitude, position.longitude),
      _positionStreamCallbackAction
    );
  }

  /// Dispose the position stream subscription
  void dispose() {
    _subject.close();
    _positionSubs?.cancel();
  }
}
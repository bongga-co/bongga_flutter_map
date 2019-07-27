import 'dart:async';

import 'package:bongga_flutter_map/src/utils/position_util.dart';
import 'package:bongga_flutter_map/src/widgets/dot_maker_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';
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
      positionStream = positionStream ?? PositionUtil.getPositionStream();
    }
      
    onReady.then((_) {
      if (positionStreamEnabled) _subscribeToPositionStream();
      
      if (!_completer.isCompleted) {
        _completer.complete();
      }
    });
  }

  @override
  MapController mapCtrl;

  MapController get mapController => mapCtrl;

  set mapController(MapController ctrl) {
    mapCtrl = ctrl;
  }

  /// Custom marker
  static Widget _buildMarker(BuildContext _) {
    return DotMarker();
  }

  /// On ready callback: this is fired when the contoller is ready
  Future<Null> get onMapReady => _completer.future;

  /// Enable or disable autocenter
  Future<void> toggleAutoCenter() async {
    autoCenter = !autoCenter;
    if (autoCenter) centerMarker();
    
    notify("toggleAutoCenter", autoCenter, toggleAutoCenter);
  }

  /// Updates the marker on the map from a position
  Future<void> updateMarkerFromPosition({
    @required Position position
  }) async {

    if (position == null) throw ArgumentError("position must not be null");
  
    LatLng point = LatLng(
      position.latitude, 
      position.longitude
    );

    try {
      await removeMarker(name: "marker");
    } catch (e) {
      print("WARNING: livemap: can not remove livemarker from map");
    }

    Marker marker = Marker(
      point: point,
      builder: _buildMarker
    );

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
  void togglePositionStreamSubscription({ 
    Stream<Position> newPositionStream 
  }) {

    positionStreamEnabled = !positionStreamEnabled;
    
    if (!positionStreamEnabled) {
      _positionSubs.cancel();
    } else {
      newPositionStream = newPositionStream ?? PositionUtil.getPositionStream();
      positionStream = newPositionStream;

      _subscribeToPositionStream();
    }

    notify(
      "positionStream", 
      positionStreamEnabled,
      togglePositionStreamSubscription
    );
  }


  void _subscribeToPositionStream() {
    _positionSubs = positionStream.listen((Position position) {
      _positionStreamCallbackAction(position);
    });
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
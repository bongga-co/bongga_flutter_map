import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:bongga_flutter_map/bongga_flutter_map.dart';

class BonggaMap extends StatefulWidget {

  final bool hasRadar;
  final MapOptions options;
  final List<LayerOptions> layers;
  final Controller controller;

  BonggaMap({
    this.hasRadar,
    this.options,
    this.layers,
    @required this.controller
  });

  @override
  _BonggaMapState createState() => _BonggaMapState();
}

class _BonggaMapState extends State<BonggaMap> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlutterMap(
          mapController: widget.controller.mapCtrl,
          options: widget.options,
          layers: widget.layers,
        ),
        Container(child: widget.hasRadar ? Radar() : null),
      ],
    );
  }
}
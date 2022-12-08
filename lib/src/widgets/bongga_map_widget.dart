import 'package:bongga_flutter_map/bongga_flutter_map.dart';
import 'package:flutter/material.dart';

class BonggaMap extends StatefulWidget {
  const BonggaMap({
    super.key,
    required this.controller,
    required this.options,
    this.layers = const <LayerOptions>[],
    this.hasRadar = false,
  });

  final Controller controller;
  final MapOptions options;
  final List<LayerOptions> layers;
  final bool hasRadar;

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
        Container(child: widget.hasRadar ? const Radar() : null),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class Map extends HookWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const MapShapeSource _dataSource = MapShapeSource.asset(
        'assets/countries.json',
        shapeDataField: 'STATE_NAME',
      );

    return Scaffold(
      body: Center(
        child: SfMaps(layers: [
          MapShapeLayer(source: _dataSource),
        ],),
      ),
    );
  }
}

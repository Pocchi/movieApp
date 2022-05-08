import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_maps/maps.dart';


class CountryModel {
  const CountryModel(this.country, this.latitude, this.longitude);

  final String country;
  final double latitude;
  final double longitude;
}

class Map extends HookWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CountryModel> _data = <CountryModel>[const CountryModel('Brazil', -14.235004, -51.92528)];
    final MapShapeSource _dataSource = MapShapeSource.asset(
      'assets/countries.json',
      shapeDataField: 'name',
      dataCount: _data.length,
      primaryValueMapper: (index) => _data[index].country,
    );

    return Scaffold(
      body: Center(
        child: SfMaps(layers: <MapLayer>[
          MapShapeLayer(
            source: _dataSource,
            initialMarkersCount: 1,
            markerBuilder: (BuildContext context, int index) {
              return MapMarker(
                latitude: _data[index].latitude,
                longitude: _data[index].longitude,
                iconColor: Colors.blue,
                child: GestureDetector(
                  onTap: () {
                    print("${index}: onTap called.");
                  },
                  child: Icon(Icons.add_location),
                ),
              );
            },
          ),
        ],),
      ),
    );
  }
}

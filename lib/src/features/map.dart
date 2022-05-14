import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:movie/src/models/globalState.dart';
import 'package:movie/src/features/movieList.dart';

class CountryModel {
  const CountryModel(this.country, this.latitude, this.longitude);

  final String country;
  final double latitude;
  final double longitude;
}

class Map extends HookConsumerWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(countryProvider.state);
    List<CountryModel> _data = <CountryModel>[
      const CountryModel('Brazil', -14.235004, -51.92528),
      const CountryModel('Germany', 51.16569, 10.451526),
      const CountryModel('Australia', -25.274398, 133.775136),
      const CountryModel('India', 20.593684, 78.96288),
      const CountryModel('Russia', 61.52401, 105.318756)
    ];
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
            initialMarkersCount: _data.length,
            markerBuilder: (BuildContext context, int index) {
              return MapMarker(
                latitude: _data[index].latitude,
                longitude: _data[index].longitude,
                iconColor: Colors.blue,
                child: GestureDetector(
                  onTap: () {
                    print("${index}: onTap called.");
                    selectedCountry.state = _data[index].country;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MovieList()));
                  },
                  child: const Icon(Icons.add_location),
                ),
              );
            },
          ),
        ],),
      ),
    );
  }
}

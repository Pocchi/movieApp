import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:movie/src/models/globalState.dart';
import 'package:movie/src/features/movieList.dart';
import 'package:movie/src/sqlite/collection.dart';
import 'package:movie/src/models/searchMovies.dart';
import 'package:collection/collection.dart';


class CountryModel {
  CountryModel(this.country, this.latitude, this.longitude, this.count);

  final String country;
  final double latitude;
  final double longitude;
  final int count;
}

late MapShapeLayerController _controller;

class Map extends HookConsumerWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(countryProvider.state);
    final countries = useState<List<CountryModel>>([]);
    final collectionNumber = useState(0);
    List<CountryModel> _data = <CountryModel>[
      CountryModel('Brazil', -14.235004, -51.92528, 0),
      CountryModel('Germany', 51.16569, 10.451526, 0),
      CountryModel('Australia', -25.274398, 133.775136, 0),
      CountryModel('India', 20.593684, 78.96288, 0),
      CountryModel('Russia', 61.52401, 105.318756, 0)
    ];
    final MapShapeSource _dataSource = MapShapeSource.asset(
      'assets/countries.json',
      shapeDataField: 'name',
      dataCount: _data.length,
      primaryValueMapper: (index) => _data[index].country,
    );

    void init() async {
      _controller = MapShapeLayerController();
      final db = await DB.instance.database;
      var counts = await CollectionDB.hasCountCountry(db);
      _data.asMap().forEach((index, element) {
        var country = element.country;
        var getCount = counts.firstWhereOrNull((item) => item.country == country);
        if (getCount != null) {
          collectionNumber.value += getCount.count;
          countries.value.add(CountryModel(element.country, element.latitude, element.longitude, getCount.count));
        } else {
          countries.value.add(element);
        }
        _controller.insertMarker(index);
      });
    }

    useEffect(() {
      init();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select"),
      ),
      body: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 20),
                      child: Text(
                        "${collectionNumber.value}/${countries.value.length}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Wrap(
                     children: countries.value.map((country) => _label(country)).toList(),
                    ),
                  ]
              )
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.95,
              child: SfMaps(layers: <MapLayer>[
                MapShapeLayer(
                  source: _dataSource,
                  initialMarkersCount: countries.value.length,
                  color: Colors.blueGrey[100],
                  strokeColor: Colors.blueGrey[230],
                  markerBuilder: (BuildContext context, int index) {
                    return MapMarker(
                      latitude: countries.value[index].latitude,
                      longitude: countries.value[index].longitude,
                      child: GestureDetector(
                        onTap: () {
                          selectedCountry.state = countries.value[index].country;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MovieList()));
                        },
                        child: Icon(
                            countries.value[index].count > 0 ? Icons.where_to_vote : Icons.flag,
                            color: countries.value[index].count > 0 ? Colors.pink.shade400.withOpacity(0.8) : Colors.teal.shade400.withOpacity(0.8),
                            size: 40,
                        ),
                      ),
                    );
                  },
                  selectionSettings: MapSelectionSettings(
                    color: Colors.orange,
                    strokeColor: Colors.red[900],
                    strokeWidth: 3,
                  ),
                  controller: _controller,
                ),
              ],
              ),
            )
          ]
      ),
    );
  }

  Widget _label(CountryModel country) {
    String text = '${country.country}: ${country.count}';
    return Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.blueGrey,
            ),
          ),
        ),
    );
  }
}

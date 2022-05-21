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
    final contries = useState<List<CountryModel>>([]);
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
        print(country);
        var getCount = counts.firstWhereOrNull((item) => item.country == country);
        if (getCount != null) {
          print(getCount.count);
          contries.value.add(CountryModel(element.country, element.latitude, element.longitude, getCount.count));
        } else {
          contries.value.add(element);
        }
        _controller.insertMarker(index);
      });
    }

    useEffect(() {
      init();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: SfMaps(layers: <MapLayer>[
          MapShapeLayer(
            source: _dataSource,
            initialMarkersCount: contries.value.length,
            markerBuilder: (BuildContext context, int index) {
              return MapMarker(
                latitude: contries.value[index].latitude,
                longitude: contries.value[index].longitude,
                child: GestureDetector(
                  onTap: () {
                    print("${index}: onTap called.");
                    selectedCountry.state = contries.value[index].country;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MovieList()));
                  },
                  child: Icon(
                      Icons.add_location,
                      color: contries.value[index].count > 0 ? Colors.red : Colors.grey,
                      size: 30,
                  ),
                ),
              );
            },
            controller: _controller,
          ),
        ],),
      ),
    );
  }
}

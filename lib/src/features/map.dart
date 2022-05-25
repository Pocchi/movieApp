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
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:async';
import 'package:movie/src/models/globalState.dart';

late MapShapeLayerController _controller;

class Map extends HookConsumerWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(countryProvider.state);
    final stateCountries = ref.watch(countriesProvider);
    final countriesNotifier = ref.read(countriesProvider.notifier);
    final collectionNumber = useState(0);
    final animationNumber = useState(0);
    final MapShapeSource _dataSource = MapShapeSource.asset(
      'assets/countries.json',
      shapeDataField: 'name',
      dataCount: stateCountries.length,
      primaryValueMapper: (index) => stateCountries[index].country,
    );

    void init() async {
      _controller = MapShapeLayerController();
      // _controller.insertMarker(index);
      countriesNotifier.initCountries();
      Timer(const Duration(seconds: 1), () => FlutterNativeSplash.remove());
      animationNumber.value += 1;
      Timer.periodic(
        const Duration(seconds: 15),
        (Timer timer) {
          animationNumber.value += 1;
        },
      );
    }

    useEffect(() {
      init();
    }, []);

    useEffect(() {
      print("stateCountries");
      for (int i = 0; i < stateCountries.length; i++) {
        // TODO: 差分だけupdateする
        _controller.updateMarkers([i]);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Country"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
          fit: StackFit.passthrough,
          children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(28, 208, 178, 0.5),
                  Color.fromRGBO(128, 208, 0, 0.4),
                  Colors.white60,
                  Colors.white60,
                  Colors.white60,
                  Color.fromRGBO(188, 208, 0, 0.5),
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 35, bottom: 20),
                      child: Text(
                        "${collectionNumber.value}/${stateCountries.length}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Wrap(
                     children: stateCountries.map((country) => _label(country)).toList(),
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
                  initialMarkersCount: stateCountries.length,
                  color: Colors.blueGrey[100],
                  strokeColor: Colors.blueGrey[230],
                  markerBuilder: (BuildContext context, int index) {
                    return MapMarker(
                      latitude: stateCountries[index].latitude,
                      longitude: stateCountries[index].longitude,
                      child: GestureDetector(
                        onTap: () {
                          selectedCountry.state = stateCountries[index].country;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MovieList()));
                        },
                        child: Icon(
                            stateCountries[index].count > 0 ? Icons.where_to_vote : Icons.flag,
                            color: stateCountries[index].count > 0 ? Colors.pink.shade400.withOpacity(0.8) : Colors.teal.shade400.withOpacity(0.8),
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
            ),
            _airplane(animationNumber.value, context),
          ]
      ),
    );
  }

  Widget _label(CountryModel country) {
    String text = '${country.country}  ${country.count}';
    return Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(30, 35, 100, 0.5),
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
              color: Colors.white,
            ),
          ),
        ),
    );
  }

  Widget _airplane(int animationNumber, context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 12500),
      top: animationNumber % 2 == 0 ? -28 : MediaQuery.of(context).size.height,
      left: animationNumber % 2 == 0 ? MediaQuery.of(context).size.width - 280 : MediaQuery.of(context).size.width - 250,
      child: Container(
        child: Icon(
            Icons.flight, size: 28,
            color: Color.fromRGBO(30, 35, 100, animationNumber % 2 == 0 ? 1 : 0),
        ),
    ),
      curve: Curves.easeInOut,
    );
  }
}

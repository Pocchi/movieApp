import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:movie/src/sqlite/collection.dart';

enum TabType { map, collectionList }
final tabTypeProvider = StateProvider<TabType>((ref) => TabType.map);
final countryProvider = StateProvider((ref) => 'Japan');

class CountryModel {
  CountryModel(this.country, this.latitude, this.longitude, this.count);

  final String country;
  final double latitude;
  final double longitude;
  int count;

  void increment() {
    count += 1;
  }

  void decrement() {
    count -= 1;
  }

  void setCount(int num) {
    count = num;
  }
}
final countriesProvider = StateNotifierProvider<Countries, List<CountryModel>>((_) => Countries());

List<CountryModel> countryData = <CountryModel>[
  CountryModel('Brazil', -14.235004, -51.92528, 0),
  CountryModel('Germany', 51.16569, 10.451526, 0),
  CountryModel('Australia', -25.274398, 133.775136, 0),
  CountryModel('India', 20.593684, 78.96288, 0),
  CountryModel('Russia', 61.52401, 105.318756, 0)
];

class Countries extends StateNotifier<List<CountryModel>> {
  Countries(): super(countryData);

  void incrementCountByCountry(String country) {
    var countryIndex = state.indexWhere((item) => item.country == country);
    state[countryIndex].increment();
  }

  void decrementCountByCountry(String country) {
    var countryIndex = state.indexWhere((item) => item.country == country);
    state[countryIndex].decrement();
  }

  Future initCountries() async {
    final db = await DB.instance.database;
    var counts = await CollectionDB.hasCountCountry(db);
    counts.asMap().forEach((index, element) {
      print(element.country);
      print(element.count);
      var country = element.country;
      var countryIndex = state.indexWhere((item) => item.country == country);
      if (countryIndex >= 0) {
        print(countryIndex);
        state[countryIndex].setCount(element.count);
        print("set");
        print(element.count);
      }
    });
  }
}





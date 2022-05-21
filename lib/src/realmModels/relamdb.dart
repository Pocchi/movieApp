import 'package:realm/realm.dart';
import 'package:movie/src/realmModels/collection.dart';

class RealmDB {
  late Realm realm;
  RealmDB() {
    final config = Configuration([Collection.schema]);
    realm = Realm(config);
  }
}
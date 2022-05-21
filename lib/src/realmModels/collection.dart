import 'package:realm/realm.dart';
part 'collection.g.dart';
@RealmModel()
class _Collection {
  @PrimaryKey()
  late int id;

  late String? title;
  late String? posterPath;
}

class CollectionModel {
  late Realm realm;

  static final CollectionModel _instance = CollectionModel._internal();

  CollectionModel._internal() {
    var config = Configuration([Collection.schema]);
    realm = Realm(config);
    // debug
    print('realm init');
  }

  factory CollectionModel() {
    return _instance;
  }

  add(int id, String? title, String? posterPath) {
    realm.write(() {
      realm.add(Collection(id, title: title, posterPath: posterPath));
    });
  }

  getAll() {
    return realm.all<Collection>();
  }

  getById(int id) {
    final item = realm.find<Collection>(id);
    return item;
  }
}

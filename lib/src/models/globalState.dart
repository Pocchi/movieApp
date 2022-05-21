import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie/src/realmModels/collection.dart';

enum TabType { map, collectionList }
final tabTypeProvider = StateProvider<TabType>((ref) => TabType.map);
final countryProvider = StateProvider((ref) => 'Japan');
final collectionProvider = StateProvider((ref) => CollectionModel());




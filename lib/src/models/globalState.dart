import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TabType { map, collectionList }
final tabTypeProvider = StateProvider<TabType>((ref) => TabType.map);
final countryProvider = StateProvider((ref) => 'Japan');




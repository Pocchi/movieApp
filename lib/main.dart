import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie/src/features/map.dart';
import 'package:movie/src/models/globalState.dart';
import 'package:movie/src/features/collectionList.dart';
import 'package:sqflite/sqflite.dart';
import 'package:movie/src/sqlite/collection.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

late Database db;

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: "assets/.env");
  var db = await DB.instance.database;
  runApp(
    const ProviderScope(
     child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Trip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(50, 50, 55, 1),
      ),
      darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue[800],
      fontFamily: 'Georgia',
      textTheme: const TextTheme(
      ),
    ),
    home: const ScreenContainer(),
    );
  }
}

class ScreenContainer extends HookConsumerWidget {
  const ScreenContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabType = ref.watch(tabTypeProvider.state);
    final _screens = [
      const Map(),
      const CollectionList(),
    ];

    return Scaffold(
      body: _screens[tabType.state.index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabType.state.index,
        onTap: (int selectIndex) {
          tabType.state = TabType.values[selectIndex];
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: tabType.state == TabType.values[0] ? Icon(Icons.map, size: 28) : Icon(Icons.map_outlined),
            label: 'map',
          ),
          BottomNavigationBarItem(
            icon: tabType.state == TabType.values[1] ? Icon(Icons.collections_bookmark, size: 28) : Icon(Icons.collections_bookmark_outlined),
            label: 'collection',
          ),
        ],
      ),
    );
  }
}

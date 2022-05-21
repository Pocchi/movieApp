import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie/src/features/searchMovies.dart';
import 'package:movie/src/features/map.dart';
import 'package:movie/src/features/movieList.dart';
import 'package:movie/src/models/globalState.dart';
import 'package:movie/src/features/movieDetail.dart';
import 'package:movie/src/features/collectionList.dart';
import 'package:sqflite/sqflite.dart';
import 'package:movie/src/sqlite/collection.dart';

late Database db;

Future main() async {
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
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey[50],
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
      // const MovieDetail(),
      // const Map(),
      // const MovieList(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            label: 'collection',
          ),
        ],
      ),
    );
  }
}

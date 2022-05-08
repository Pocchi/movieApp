import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie/src/features/searchMovies.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(
    const ProviderScope(
     child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Trip',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue[800],
      fontFamily: 'Georgia',
      textTheme: const TextTheme(
      ),
    ),
    home: const SearchMovies(),
    );
  }
}
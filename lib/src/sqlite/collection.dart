import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:movie/src/models/searchMovies.dart';

class DB {
  static final DB _db = DB._internal();
  DB._internal();
  static DB get instance => _db;
  late Database _database;

  Future<Database> get database async {
    _database = await _init();
    return _database;

  }

  Future<Database> _init() async{
    return await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE collection(id INTEGER PRIMARY KEY, title TEXT, posterPath TEXT, country TEXT)",
        );
      },
      version: 1,
    );
  }
}

class CollectionDB {

  static Future<bool> hasById(Database db, int id) async {
    final List<Map<String, dynamic>> data = await db.query('collection',
        where: 'id  = ?',
        whereArgs: [id]);
    return data.isNotEmpty;
  }

  static Future<List<CollectionCountModel>> hasCountCountry(Database db) async {
    final List<Map<String, dynamic>> data = await db.rawQuery(
      'SELECT country, COUNT(country) as count FROM collection GROUP BY country'
    );

    return List.generate(data.length, (i) {
      return CollectionCountModel(
        country: data[i]['country'],
        count: data[i]['count'],
      );
    });
  }

  static Future<List<CollectionModel>> all(Database db) async {
    final List<Map<String, dynamic>> data = await db.query('collection');

    return List.generate(data.length, (i) {
      return CollectionModel(
        id: data[i]['id'],
        title: data[i]['title'],
        posterPath: data[i]['posterPath'],
        country: data[i]['country'],
      );
    });
  }

  static Future<void> insert(Database db, CollectionModel collection) async {
     await db.insert(
       'collection', // テーブル名
       collection.toMap(), // データ
     );
   }

  static Future<void> delete(Database db, int id) async {
    await db.delete(
      'collection', // テーブル名
       where: 'id  = ?',
       whereArgs: [id]
    );
  }
}


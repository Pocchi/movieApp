import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:movie/src/models/searchMovies.dart';
import 'package:movie/src/sqlite/collection.dart';
import 'package:sqflite/sqflite.dart';
import 'package:movie/src/apis/movie.dart';

class MovieDetail extends HookConsumerWidget {
  final int id;
  final String country;
  const MovieDetail({Key? key, required this.id, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieApi = MovieApi();
    late Database db;
    bool _hasBool = false;
    final movie = useState<MovieDetailModel?>(null);
    void _setHas(bool setBool) {
      _hasBool = setBool;
    }

    void init() async {
      print('init');
      db = await DB.instance.database;
      _hasBool = await CollectionDB.hasById(db, id);
      final data = await movieApi.fetchMovie(id);
      Map<String, dynamic> decodeData = data;
      movie.value = MovieDetailModel.fromJson(decodeData);
    }

    useEffect(() {
      init();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: movie.value != null ? Column(
        children: [
          _imageView(movie.value!),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: IconButton(
                onPressed: () async {
                  if (_hasBool) {
                    // コレクションから削除
                    var result = await CollectionDB.delete(db, id);
                    _setHas(false);
                  } else {
                    // コレクションに保存
                    var collection = CollectionModel(id: id, title: movie.value?.title, posterPath: movie.value?.posterPath, country: country);
                    var result = await CollectionDB.insert(db, collection);
                    _setHas(true);
                  }
                },
                icon: Icon(
                  Icons.star,
                  color: _hasBool ? Colors.yellow : Colors.grey,
                  size: 35,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5,left: 15, right: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              movie.value?.title ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10,left: 15, right: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              movie.value?.overview ?? '',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15,left: 15, right: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              '公開日: ${movie.value?.releaseDate}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ) : Container(),
    );
  }

  Widget _imageView(MovieDetailModel movie) {
    String? backdropPath = movie.backdropPath;
    String? posterPath = movie.posterPath;
    String? path = backdropPath ?? posterPath;
    const imagePath = 'https://image.tmdb.org/t/p/w500';
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: path == null ? _noImageView(movie)
          : Image.network("$imagePath$path", fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _noImageView(movie);
          }),
    );
  }
  Widget _noImageView(MovieDetailModel movie) {
    const noImage = 'assets/images/noimage@3x.png';
    return Stack(alignment: AlignmentDirectional.center,
        children:[
          Image.asset(noImage, fit: BoxFit.cover),
        ]
    );
  }
}

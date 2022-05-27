import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:movie/src/models/searchMovies.dart';
import 'package:movie/src/sqlite/collection.dart';
import 'package:movie/src/apis/movie.dart';
import 'package:movie/src/models/globalState.dart';

class MovieDetail extends HookConsumerWidget {
  final int id;
  final String country;

  const MovieDetail({Key? key, required this.id, required this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieApi = MovieApi();
    final movie = useState<MovieDetailModel?>(null);
    final hasBool = useState<bool>(false);
    final countriesNotifier = ref.read(countriesProvider.notifier);

    void init() async {
      final db = await DB.instance.database;
      hasBool.value = await CollectionDB.hasById(db, id);
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
        backgroundColor: Theme.of(context).primaryColor,
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
                  final db = await DB.instance.database;
                  if (hasBool.value) {
                    // コレクションから削除
                    var result = await CollectionDB.delete(db, id);
                    hasBool.value = false;
                  } else {
                    // コレクションに保存
                    var collection = CollectionModel(id: id,
                        title: movie.value?.title,
                        posterPath: movie.value?.posterPath,
                        country: country);
                    var result = await CollectionDB.insert(db, collection);
                    hasBool.value = true;
                  }
                  await countriesNotifier.initCountries();
                },
                icon: Icon(
                  Icons.star,
                  color: hasBool.value ? Colors.yellow : Colors.grey,
                  size: 35,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
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
          _textView(movie.value?.overview),
          _textView(movie.value?.tagline),
          _textView('公開日: ${movie.value?.releaseDate}'),
          _textView('ステータス: ${movie.value?.status}'),
        ],
      ) : Container(),
    );
  }

  Widget _textView(String? text) {
    if (text == null) return Container();
   return Container(
       padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
       alignment: Alignment.centerLeft,
       child: Text(
         text,
         style: const TextStyle(
           fontSize: 15,
           color: Colors.black,
         ),
       ),
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

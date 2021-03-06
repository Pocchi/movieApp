import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:movie/src/models/searchMovies.dart';
import 'package:movie/src/sqlite/collection.dart';
import 'package:movie/src/apis/movie.dart';
import 'package:movie/src/models/globalState.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';

late ConfettiController _controllerCenter;

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
    final stateCountries = ref.watch(countriesProvider);
    final countriesNotifier = ref.read(countriesProvider.notifier);

    void init() async {
      final db = await DB.instance.database;
      hasBool.value = await CollectionDB.hasById(db, id);
      final data = await movieApi.fetchMovie(id);
      Map<String, dynamic> decodeData = data;
      movie.value = MovieDetailModel.fromJson(decodeData);
      _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
    }

    void dialog() async {
      _controllerCenter.play();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: pi / 2,
                numberOfParticles: 30,
                gravity: 0.3,
                canvas: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
              )
            ),
            AlertDialog(
              title: const Text('??????????????????????????????????????????',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '${countriesNotifier.hasCountryCount()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Color.fromRGBO(28, 108, 118, 1),
                        wordSpacing: 0,
                        letterSpacing: 5,
                      ),
                    ),
                    TextSpan(text: '/${stateCountries.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color.fromRGBO(108, 108, 118, 1),
                        wordSpacing: 0,
                        letterSpacing: 5,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('?????????'),
                ),
              ],
            )
          ])
      );
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
                    // ??????????????????????????????
                    var result = await CollectionDB.delete(db, id);
                    hasBool.value = false;
                  } else {
                    // ???????????????????????????
                    var collection = CollectionModel(id: id,
                        title: movie.value?.title,
                        posterPath: movie.value?.posterPath,
                        country: country);
                    var result = await CollectionDB.insert(db, collection);
                    hasBool.value = true;
                  }
                  final showDialog = !hasBool.value && countriesNotifier.hasCountry(country);
                  await countriesNotifier.initCountries();
                  if (!showDialog) {
                    dialog();
                  }
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
          _textView('?????????: ${movie.value?.releaseDate}'),
          _textView('???????????????: ${movie.value?.status}'),
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

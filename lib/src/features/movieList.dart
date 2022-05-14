import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:movie/src/apis/movie.dart';
import 'package:movie/src/models/globalState.dart';
import 'package:movie/src/models/searchMovies.dart';
import 'dart:convert';

const double itemWidth = 220;
const double itemHeight = 330;

class MovieList extends HookConsumerWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieApi = MovieApi();
    final selectedCountry = ref.watch(countryProvider.state);
    final searchMovie = useState<SearchMovieModel?>(null);
    final movies = useState<List<MovieResultModel>>([]);

    void fetchData(int page) async {
      print(selectedCountry.state);
      final data = await movieApi.fetchSearch(page, selectedCountry.state);
      Map<String, dynamic> decodeData = data;
      var resultData = decodeData['results'];
      resultData.forEach((item) => movies.value.add(MovieResultModel.fromJson(item)));
      searchMovie.value = SearchMovieModel.fromJson(decodeData);
    }

    useEffect(() {
      fetchData(1);
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('検索した映画'),
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 4,
          padding: const EdgeInsets.all(1),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: (itemWidth / itemHeight),
          children: movies.value.map((movie) => _listItem(movie)).toList(),
        )
      ),
    );
  }

  Widget _listItem(MovieResultModel movie) {
    const noImage = 'assets/images/noimage@3x.png';
    String? posterImage = movie.posterPath;
    const imagePath = 'https://image.tmdb.org/t/p/w500/';
    return SizedBox(
      height: itemHeight,
      width: itemWidth,
      child: posterImage == null ? Image.asset(noImage, fit: BoxFit.cover) : Image.network("$imagePath$posterImage", fit: BoxFit.cover)
    );
  }
}



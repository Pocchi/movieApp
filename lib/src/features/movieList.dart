import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie/src/apis/movie.dart';
import 'package:movie/src/models/globalState.dart';
import 'package:movie/src/models/searchMovies.dart';
import 'package:movie/src/features/movieDetail.dart';

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
    final ScrollController _scrollController = ScrollController();
    final requestPage = useState(1); // 現在リクエスト中のページ
    final resultsText = useState('');

    void fetchData(int page) async {
      print(selectedCountry.state);
      final data = await movieApi.fetchSearch(page, selectedCountry.state);
      Map<String, dynamic> decodeData = data;
      var resultData = decodeData['results'];
      resultData.forEach((item) => movies.value.add(MovieResultModel.fromJson(item)));
      searchMovie.value = SearchMovieModel.fromJson(decodeData);
      resultsText.value = "${movies.value.length}/${searchMovie.value?.totalResults ?? ''}";
    }

    useEffect(() {
      fetchData(1);
    }, []);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent <= _scrollController.position.pixels) {
        int requestedPage = searchMovie.value?.page ?? 1;
        int totalPages = searchMovie.value?.totalPages ?? 1;
        if (requestPage.value == requestedPage && requestPage.value < totalPages) {
          fetchData(requestPage.value + 1);
          requestPage.value++;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("${selectedCountry.state} Movies"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return GestureDetector(
                        child: _listItem(movies.value[index]),
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MovieDetail(id: movies.value[index].id, country: selectedCountry.state)),
                          );
                        }),
                    );
                  },
                  childCount: movies.value.length,
                  )
                ),
                const SliverToBoxAdapter(
                  child: Padding(padding: EdgeInsets.only(bottom: 150)),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text(resultsText.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.white,
                      height: 1.6,
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
                    ))
            ),
        ]
      ),
    );
  }

  Widget _listItem(MovieResultModel movie) {
    String? posterImage = movie.posterPath;
    const imagePath = 'https://image.tmdb.org/t/p/w500';
    return SizedBox(
        height: itemHeight,
        width: itemWidth,
        child: posterImage == null ?
          _noImageView(movie)
          : Image.network("$imagePath$posterImage", fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _noImageView(movie);
              }),
    );
  }

  Widget _noImageView(MovieResultModel movie) {
    const noImage = 'assets/images/noimage@3x.png';
    return Stack(alignment: AlignmentDirectional.center,
          children:[
            Image.asset(noImage, fit: BoxFit.cover),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text(movie.title ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.white,
                      height: 1.6,
                    ))
            )
          ]
      );
  }
}



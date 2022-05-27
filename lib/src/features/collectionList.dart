import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie/src/models/searchMovies.dart';
import 'package:movie/src/features/movieDetail.dart';
import 'package:movie/src/sqlite/collection.dart';

const double itemWidth = 220;
const double itemHeight = 330;

class CollectionList extends HookConsumerWidget {
  const CollectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = useState<List<CollectionModel>>([]);
    final ScrollController _scrollController = ScrollController();
    final resultsText = useState('');

    void fetchData() async {
      final db = await DB.instance.database;
      movies.value = await CollectionDB.all(db);
    }

    useEffect(() {
      fetchData();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Collections"),
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
                        onTap: (() async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MovieDetail(id: movies.value[index].id, country: movies.value[index].country)),
                          );
                          fetchData();
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

  Widget _listItem(CollectionModel movie) {
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

  Widget _noImageView(CollectionModel movie) {
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



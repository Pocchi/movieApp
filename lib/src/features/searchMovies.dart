import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movie/src/apis/movie.dart';

class SearchMovies extends HookWidget {
  const SearchMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchText = useState('');
    final movieApi = MovieApi();

    return Scaffold(
      appBar: AppBar(
        title: const Text('映画を探す'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: TextEditingController(text: searchText.value),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: '探す映画のキーワード',
              ),
              onFieldSubmitted: (value) async {

                 final data = await movieApi.fetchSearch(1, searchText.value);
              },
            ),
          ],
        ),
      ),
    );
  }
}



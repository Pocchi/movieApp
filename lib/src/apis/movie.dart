import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const apiUrl = 'https://api.themoviedb.org/3';
const language = 'ja-JP';
class MovieApi {
  dynamic fetchSearch(int page, String keyword) async {

    print(dotenv.env['MOVIEDB_APIKEY']);
    print(language);
    print(keyword);
    print(page);
    try{
      final response = await Dio().get(
          '$apiUrl/search/movie',
          queryParameters: {
            'api_key': dotenv.env['MOVIEDB_APIKEY'],
            'language': language,
            'query': 'keyword',
            'page': page,
            'include_adult': 'false'
          }
      );
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
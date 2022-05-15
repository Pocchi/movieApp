import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie/src/models/searchMovies.dart';

const apiUrl = 'https://api.themoviedb.org/3';
const language = 'ja';
class MovieApi {
  dynamic fetchSearch(int page, String keyword) async {
    try{
      final response = await Dio().get(
          '$apiUrl/search/movie',
          queryParameters: {
            'api_key': dotenv.env['MOVIEDB_APIKEY'],
            'language': language,
            'query': keyword,
            'page': page,
            'include_adult': 'false'
          }
      );
      return response.data;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}


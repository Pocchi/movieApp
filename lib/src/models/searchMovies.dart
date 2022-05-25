class SearchMovieModel {
  final int page;
  // final List<MovieResultModel> results;
  final int totalPages;
  final int totalResults;

  SearchMovieModel({
    required this.page,
    // required this.results,
    required this.totalPages,
    required this.totalResults
  });

  Map<String, dynamic> toMap() {
    return {
    'page': page,
    // 'results': results,
    'totalPages': totalPages,
    'totalResults': totalResults,
    };
  }

  factory SearchMovieModel.fromJson(Map<String, dynamic> json) {
    return SearchMovieModel(
      page: json['page'] as int,
      // results: json['results'] as List<MovieResultModel>,
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }
}

class MovieResultModel {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double voteAverage;
  final int? voteCount;

  MovieResultModel({
    this.adult,
    this.backdropPath,
    this.genreIds,
    required this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    required this.voteAverage,
    this.voteCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'adult': adult,
      'backdropPath': backdropPath,
      'genreIds': genreIds,
      'id': id,
      'originalLanguage': originalLanguage,
      'originalTitle': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'title': title,
      'video': video,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
    };
  }

  factory MovieResultModel.fromJson(Map<String, dynamic> json) {
    return MovieResultModel(
        adult: json['adult'] as bool?,
        backdropPath: json['backdrop_path'] as String?,
        genreIds: json['genreIds'] as List<int>?,
        id: json['id'] as int,
        originalLanguage: json['original_language'] as String?,
        originalTitle: json['original_title'] as String?,
        overview: json['overview'] as String?,
        popularity: json['popularity'].toDouble(),
        posterPath: json['poster_path'] as String?,
        releaseDate: json['release_date'] as String?,
        title: json['title'] as String?,
        video: json['video'] as bool?,
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['voteCount'] as int?,
    );
  }
}

class CollectionModel {
  final int id;
  final String? title;
  final String? posterPath;
  final String country;

  CollectionModel({
    required this.id,
    this.title,
    this.posterPath,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'country': country,
    };
  }
}

class CollectionCountModel {
  final String country;
  final int count;

  CollectionCountModel({
    required this.country,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'count': count,
    };
  }
}

class MovieDetailModel {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double voteAverage;
  final int? voteCount;
  final String? status;
  final String? tagline;

  MovieDetailModel({
    this.adult,
    this.backdropPath,
    this.genreIds,
    required this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    required this.voteAverage,
    this.voteCount,
    this.status,
    this.tagline,
  });

  Map<String, dynamic> toMap() {
    return {
      'adult': adult,
      'backdropPath': backdropPath,
      'genreIds': genreIds,
      'id': id,
      'originalLanguage': originalLanguage,
      'originalTitle': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'title': title,
      'video': video,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
      'status': status,
      'tagline': tagline,
    };
  }

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      adult: json['adult'] as bool?,
      backdropPath: json['backdrop_path'] as String?,
      genreIds: json['genreIds'] as List<int>?,
      id: json['id'] as int,
      originalLanguage: json['original_language'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      popularity: json['popularity'].toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      title: json['title'] as String?,
      video: json['video'] as bool?,
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['voteCount'] as int?,
      status: json['status'] as String?,
      tagline: json['tagline'] as String?,
    );
  }
}

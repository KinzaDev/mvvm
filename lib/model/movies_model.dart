import 'package:mvvm/res/movie_posters.dart';

class MovieListModel {
  List<Movies>? movies;

  MovieListModel({this.movies});

  MovieListModel.fromJson(dynamic json) {
    if (json is Map && json['movies'] != null) {
      movies = <Movies>[];
      json['movies'].forEach((v) {
        movies!.add(Movies.fromJson(v));
      });
    } else if (json is List) {
      movies = <Movies>[];
      for (var v in json) {
        movies!.add(Movies.fromJson(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (movies != null) {
      data['movies'] = movies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Movies {
  String? id;
  String? title;
  String? year;
  List<String>? genres;
  List<int>? ratings;
  String? poster;
  dynamic contentRating;
  String? duration;
  String? releaseDate;
  dynamic averageRating;
  String? originalTitle;
  String? storyline;
  List<String>? actors;
  dynamic imdbRating;
  String? posterurl;

  Movies({
    this.id,
    this.title,
    this.year,
    this.genres,
    this.ratings,
    this.poster,
    this.contentRating,
    this.duration,
    this.releaseDate,
    this.averageRating,
    this.originalTitle,
    this.storyline,
    this.actors,
    this.imdbRating,
    this.posterurl,
  });

  Movies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    genres = json['genres']?.cast<String>();
    if (json['ratings'] != null && json['ratings'] is List) {
      ratings = <int>[];
      for (var v in json['ratings']) {
        if (v is int) {
          ratings!.add(v);
        } else if (v is num) {
          ratings!.add(v.round());
        } else if (v != null) {
          final parsed = int.tryParse(v.toString());
          if (parsed != null) {
            ratings!.add(parsed);
          }
        }
      }
    }
    poster = json['poster'];
    contentRating = json['contentRating'];
    duration = json['duration'];
    releaseDate = json['releaseDate'];
    averageRating = json['averageRating'];
    originalTitle = json['originalTitle'];
    storyline = json['storyline'];
    actors = json['actors']?.cast<String>();
    imdbRating = json['imdbRating'];
    posterurl = MoviePosters.getPoster(title, originalTitle, json['posterurl']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['year'] = year;
    data['genres'] = genres;
    data['ratings'] = ratings;
    data['poster'] = poster;
    data['contentRating'] = contentRating;
    data['duration'] = duration;
    data['releaseDate'] = releaseDate;
    data['averageRating'] = averageRating;
    data['originalTitle'] = originalTitle;
    data['storyline'] = storyline;
    data['actors'] = actors;
    data['imdbRating'] = imdbRating;
    data['posterurl'] = posterurl;
    return data;
  }
}

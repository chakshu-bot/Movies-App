import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDbService {
  final String apiKey = '24001f5bf151394357a2aaad6584b223';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchMovies(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint?api_key=$apiKey'));
    print('API Response: ${response.statusCode} ${response.body}');  // Debug log
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> fetchTrendingMovies() async {
    return fetchMovies('trending/movie/day');
  }

  Future<List<Movie>> fetchUpcomingMovies() async {
    return fetchMovies('movie/upcoming');
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    return fetchMovies('movie/now_playing');
  }

  Future<List<Movie>> fetchPopularMovies() async {
    return fetchMovies('movie/popular');
  }

  Future<List<Movie>> fetchRelatedMovies(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load related movies');
    }
  }

  Future<List<String>> fetchMovieClips(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final videos = jsonResponse['results'] as List;

      // Filter for YouTube videos (or other platforms if needed)
      final videoKeys = videos
          .where((video) => video['site'] == 'YouTube')
          .map<String>((video) => video['key'])
          .toList();
      return videoKeys;
    } else {
      throw Exception('Failed to load video clips');
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json1 = json.decode(response.body);
      return Movie.fromJson(json1);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}

class Movie {
  final String imageUrl;
  final String title;
  final String description;
  final double rating;
  final int id;

  Movie({required this.imageUrl, required this.title, required this.description, required this.rating, required this.id});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imageUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      title: json['title'],
      description: json['overview'],
      rating: json['vote_average'].toDouble(),
      id: json['id'],
    );
  }
}


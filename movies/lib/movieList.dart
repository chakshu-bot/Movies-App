import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies/shimmer.dart';
import 'TMDBServer.dart';
import 'movie_details.dart';

class MovieList extends StatelessWidget {
  final String endpoint;
  final TMDbService tmdbService = TMDbService();

  MovieList({required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _fetchMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  const ShimmerList();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No movies found'));
        } else {
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetails(movie: movie),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        height: 80, // Increased height
                        width: 100, // Increased width
                        child: CachedNetworkImage(
                          imageUrl: movie.imageUrl,
                          placeholder: (context, url) => const ShimmerImage(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.cover, // Ensure the image fits the container
                        ),
                      ),
                      const SizedBox(width: 16.0), // Space between image and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 8.0), // Space between title and rating
                            Text(
                              'Rating: ${movie.rating}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Movie>> _fetchMovies() {
    switch (endpoint) {
      case 'trending/movie/day':
        return tmdbService.fetchTrendingMovies();
      case 'movie/upcoming':
        return tmdbService.fetchUpcomingMovies();
      case 'movie/now_playing':
        return tmdbService.fetchNowPlayingMovies();
      case 'movie/popular':
        return tmdbService.fetchPopularMovies();
      default:
        return tmdbService.fetchPopularMovies();
    }
  }
}

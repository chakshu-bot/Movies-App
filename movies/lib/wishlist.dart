import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies/movie_details.dart';
import 'package:movies/shimmer.dart';
import 'TMDBServer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  late Future<List<Movie>> _wishlistMovies;

  @override
  void initState() {
    super.initState();
    _wishlistMovies = _loadWishlistMovies();
  }

  Future<List<Movie>> _loadWishlistMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? wishlist = prefs.getStringList('wishlist') ?? [];
    List<Movie> movies = [];
    for (String id in wishlist) {
      Movie movie = await TMDbService().fetchMovieDetails(int.parse(id));
      movies.add(movie);
    }
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _wishlistMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies in wishlist.'));
          } else {
            List<Movie> movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                Movie movie = movies[index];
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
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/shimmer.dart';

import 'TMDBServer.dart';
import 'movie_details.dart';

class RelatedMovies extends StatelessWidget {
  final Future<List<Movie>> relatedMovies;
  const RelatedMovies({super.key, required this.relatedMovies});

  @override
  Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Movies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<List<Movie>>(
            future: relatedMovies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No related movies found');
              } else {
                return SizedBox(
                  height: 200, // Increased height to fit all content
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!
                        .where((movie) =>
                    movie.rating > 0) // Filter movies with rating > 0
                        .map((movie) => Container(
                      width: 120, // Set a fixed width for each item
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetails(movie: movie),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2.0,
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: movie.imageUrl,
                                placeholder: (context, url) =>
                                    const ShimmerImage(),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                                width: 100,
                                // Fixed width for the image
                                height: 120,
                                // Fixed height for the image
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      maxLines:
                                      1, // Limit title to 1 line
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    // Spacing between title and rating
                                    Text(
                                      'Rating: ${movie.rating}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                );
              }
            },
          ),
        ],
      );
    }
  }


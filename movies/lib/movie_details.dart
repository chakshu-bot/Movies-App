import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies/relatedClips.dart';
import 'package:movies/relatedMovies.dart';
import 'TMDBServer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetails extends StatefulWidget {
  final Movie movie;

  const MovieDetails({required this.movie});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<List<Movie>> _relatedMovies;
  late Future<List<String>> _movieClips;
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    _relatedMovies = TMDbService().fetchRelatedMovies(widget.movie.id);
    _movieClips = TMDbService().fetchMovieClips(widget.movie.id);
    _loadWishlistStatus();
  }

  Future<void> _loadWishlistStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String>? wishlist = prefs.getStringList('wishlist') ?? [];
      isWishlisted = wishlist.contains(widget.movie.id.toString());
    });
  }

  Future<void> _toggleWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? wishlist = prefs.getStringList('wishlist') ?? [];
    if (isWishlisted) {
      wishlist.remove(widget.movie.id.toString());
    } else {
      wishlist.add(widget.movie.id.toString());
    }
    await prefs.setStringList('wishlist', wishlist);
    setState(() {
      isWishlisted = !isWishlisted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: widget.movie.imageUrl,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 10),
              Text(
                widget.movie.title,
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.movie.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Rating: ${widget.movie.rating}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Want to watch later',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      isWishlisted ? Icons.bookmark : Icons.bookmark_border,
                    ),
                    onPressed: _toggleWishlist,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              RelatedClips(movieClips: _movieClips),
              const SizedBox(height: 10),
              RelatedMovies(relatedMovies: _relatedMovies),
            ],
          ),
        ),
      ),
    );
  }
}

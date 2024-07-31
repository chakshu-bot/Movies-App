import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:movies/shimmer.dart';
import 'dart:convert';

import 'TMDBServer.dart';
import 'movie_details.dart';

class SearchMoviesScreen extends StatefulWidget {
  @override
  _SearchMoviesScreenState createState() => _SearchMoviesScreenState();
}

class _SearchMoviesScreenState extends State<SearchMoviesScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final String apiKey = '24001f5bf151394357a2aaad6584b223'; // Replace with your TMDb API key
  List<dynamic> searchResults = [];

  Future<void> _searchMovies() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState?.value ?? {};

      final query = values['query'] ?? '';
      final page = values['page'] ?? 1;
      final includeAdult = values['include_adult'] ?? false;
      final language = values['language'] ?? 'en-US';
      final region = values['region'] ?? 'US';
      final year = values['year'] ?? '';
      final sortBy = values['sort_by'] ?? 'popularity.desc';

      final url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey'
            '&query=$query'
            '&page=$page'
            '&include_adult=$includeAdult'
            '&language=$language'
            '&region=$region'
            '&year=$year'
            '&sort_by=$sortBy',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          searchResults = data['results'] ?? [];
        });
      } else {
        // Handle errors here
        print('Failed to load search results');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'query',
                        decoration: const InputDecoration(labelText: 'Search Query'),
                        initialValue: '',
                      ),
                      FormBuilderTextField(
                        name: 'page',
                        decoration: const InputDecoration(labelText: 'Page Number'),
                        initialValue: '1',
                        keyboardType: TextInputType.number,
                      ),
                      FormBuilderSwitch(
                        name: 'include_adult',
                        title: const Text('Include Adult Content'),
                        initialValue: false,
                      ),
                      FormBuilderTextField(
                        name: 'language',
                        decoration: const InputDecoration(labelText: 'Language'),
                        initialValue: 'en-US',
                      ),
                      FormBuilderTextField(
                        name: 'region',
                        decoration: const InputDecoration(labelText: 'Region'),
                        initialValue: 'US',
                      ),
                      FormBuilderTextField(
                        name: 'year',
                        decoration: const InputDecoration(labelText: 'Release Year'),
                        initialValue: '',
                        keyboardType: TextInputType.number,
                      ),
                      FormBuilderDropdown(
                        name: 'sort_by',
                        decoration: const InputDecoration(labelText: 'Sort By'),
                        initialValue: 'popularity.desc',
                        items: [
                          'popularity.desc',
                          'popularity.asc',
                          'release_date.desc',
                          'release_date.asc',
                          'vote_average.desc',
                          'vote_average.asc'
                        ].map((sortBy) => DropdownMenuItem(
                          value: sortBy,
                          child: Text(sortBy),
                        )).toList(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _searchMovies,
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetails(movie: Movie.fromJson(searchResults[index])),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            height: 80, // Increased height
                            width: 100, // Increased width
                            child: CachedNetworkImage(
                              imageUrl: 'https://image.tmdb.org/t/p/w500${searchResults[index]['poster_path']}',
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
                                  searchResults[index]['title'] ?? 'No Title',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0), // Space between title and rating
                                Text(
                                  'Rating: ${searchResults[index]['vote_average'] ?? 'N/A'}',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movies/bottom_nav_bar.dart';
import 'package:movies/splash.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'movieList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Movie App'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Trending'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Now Playing'),
                Tab(text: 'Popular'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MovieList(endpoint: 'trending/movie/day'),
              MovieList(endpoint: 'movie/upcoming'),
              MovieList(endpoint: 'movie/now_playing'),
              MovieList(endpoint: 'movie/popular'),
            ],
          ),
      ),
    );
  }
}

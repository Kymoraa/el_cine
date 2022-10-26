import 'package:el_cine/screens/reviews.dart';
import 'package:el_cine/screens/similar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/theme_light.dart';
import 'about.dart';

class FullMovieDetails extends StatefulWidget {
  const FullMovieDetails({
    Key? key,
    required this.movieID,
    required this.movieTitle,
    required this.moviePoster,
    required this.movieReleaseDate,
    required this.movieDesc,
    required this.movieRating,
  }) : super(key: key);

  final String movieID;
  final String movieTitle;
  final String moviePoster;
  final String movieReleaseDate;
  final String movieDesc;
  final double movieRating;

  @override
  State<FullMovieDetails> createState() => _FullMovieDetailsState();
}

class _FullMovieDetailsState extends State<FullMovieDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Tab> tabs = <Tab>[
    const Tab(text: 'About'),
    const Tab(text: 'Reviews'),
    const Tab(text: 'Similar'),
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabs.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MovieThemeLight.theme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.movieTitle),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(CupertinoIcons.back),
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(
                    context,
                  );
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: CupertinoColors.activeOrange,
              labelColor: CupertinoColors.secondaryLabel,
              labelStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
              indicatorWeight: 3,
              controller: _tabController,
              tabs: tabs,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  AboutMovie(
                    movieID: widget.movieID,
                    moviePoster: widget.moviePoster,
                    movieReleaseDate: widget.movieReleaseDate,
                    movieDesc: widget.movieDesc,
                    movieRating: widget.movieRating,
                  ),
                  MovieReviews(
                    movieID: widget.movieID,
                  ),
                  SimilarMovies(
                    movieID: widget.movieID,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

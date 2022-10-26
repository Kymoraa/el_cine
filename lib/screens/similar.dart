import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/constants.dart';
import 'movie_details.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:developer';

class SimilarMovies extends StatefulWidget {
  const SimilarMovies({
    Key? key,
    required this.movieID,
  }) : super(key: key);
  final String movieID;

  @override
  State<SimilarMovies> createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  List similarMovies = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  Future<void> _getSimilarMovies() async {
    final url = Uri.parse(Constants.baseUrl + widget.movieID + Constants.similarMovies);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        similarMovies = data.values.toList()[1];
      });
    } else {
      throw Exception('Failed to load similar movies.');
    }
  }

  @override
  void initState() {
    super.initState();
    _getSimilarMovies();
  }

  @override
  Widget build(BuildContext context) {
    if (similarMovies.isEmpty) {
      return const Center(
        child: Text(
          'No similar movies to display',
          style: TextStyle(color: CupertinoColors.systemOrange),
        ),
      );
    } else {
      return Scaffold(
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullDown: true,
          enablePullUp: true,
          header: const WaterDropHeader(),
          child: GridView.builder(
            itemCount: similarMovies.length,
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (120.0 / 185.0),
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              //similarMovies.removeWhere((item) => similarMovies[index]['poster_path'] == null);
              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (_) => FullMovieDetails(
                        movieID: similarMovies[index]['id'].toString(),
                        movieTitle: similarMovies[index]['title'],
                        moviePoster: similarMovies[index]['poster_path'] != null
                            ? Constants.imageBaseUrl + similarMovies[index]['poster_path']
                            : 'null',
                        movieReleaseDate: similarMovies[index]['release_date'],
                        movieDesc: similarMovies[index]['overview'],
                        movieRating: double.parse((similarMovies[index]['vote_average']).toStringAsFixed(1)),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: similarMovies[index]['poster_path'] != null
                          ? NetworkImage(Constants.imageBaseUrl + similarMovies[index]['poster_path'])
                          : const AssetImage('assets/images/poster_unavailable.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}

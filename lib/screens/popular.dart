import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/constants.dart';
import 'movie_details.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';

class Popular extends StatefulWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  late List popularMovies;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    popularMovies = [];
    _getPopularMovies();
  }

  void _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    if(mounted) {
      setState(() {
      });
    }
    _refreshController.loadComplete();
  }

  Future<void> _getPopularMovies() async {
    final url = Uri.parse(Constants.mostPopular);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        popularMovies = data.values.toList()[1];
      });
    } else {
      throw Exception('Failed to load popular movies.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        child: GridView.builder(
          itemCount: popularMovies.length,
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (120.0 / 185.0),
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            popularMovies.removeWhere((item) => popularMovies[index]['poster_path'] == null);
            return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => FullMovieDetails(
                      movieID: popularMovies[index]['id'].toString(),
                      movieTitle: popularMovies[index]['title'],
                      moviePoster: Constants.imageBaseUrl + popularMovies[index]['poster_path'],
                      movieReleaseDate: popularMovies[index]['release_date'],
                      movieDesc: popularMovies[index]['overview'],
                      movieRating: double.parse((popularMovies[index]['vote_average']).toStringAsFixed(1)),
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: NetworkImage(Constants.imageBaseUrl + popularMovies[index]['poster_path']),
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

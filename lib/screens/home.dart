import 'dart:convert';
import 'package:el_cine/screens/coming_soon.dart';
import 'package:el_cine/screens/now_playing.dart';
import 'package:el_cine/screens/top_rated.dart';
import 'package:el_cine/screens/trending_movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String movieTitle, movieID, trailerID;
  late List trendingMovies, nowPlaying, topRated, comingSoon;

  Future<void> _getTrendingMovies() async {
    final url = Uri.parse(Constants.trendingMovie);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        trendingMovies = data.values.toList()[1];
      });
    } else {
      throw Exception('Failed to load trending movies.');
    }
  }

  Future<void> _getNowPlayingMovies() async {
    final url = Uri.parse(Constants.nowPlaying);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nowPlaying = data.values.toList()[2];
      });
    } else {
      throw Exception('Failed to load now playing movies.');
    }
  }

  Future<void> _getComingSoon() async {
    final url = Uri.parse(Constants.comingSoon);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        comingSoon = data.values.toList()[2];
      });
    } else {
      throw Exception('Failed to load coming soon movies.');
    }
  }

  Future<void> _getTopRated() async {
    final url = Uri.parse(Constants.topRated);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        topRated = data.values.toList()[1];
      });
    } else {
      throw Exception('Failed to load top rated movies.');
    }
  }

  @override
  void initState() {
    super.initState();
    trendingMovies = nowPlaying = topRated = comingSoon = [];
    _getTrendingMovies();
    _getNowPlayingMovies();
    _getComingSoon();
    _getTopRated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Cine'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TrendingMovie(trendingMovies: trendingMovies),
            const SizedBox(
              height: 30,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: const [
                      Icon(
                        CupertinoIcons.play_circle,
                        color: CupertinoColors.systemGrey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Now Playing',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: CupertinoColors.systemGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                NowPlaying(nowPlaying: nowPlaying),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Container(
            //       margin: const EdgeInsets.only(left: 30),
            //       child: const Text(
            //         'Top Rated',
            //         style: TextStyle(
            //           fontSize: 15.0,
            //           color: CupertinoColors.systemOrange,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //     TopRated(topRated: topRated),
            //   ],
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: const [
                      Icon(
                        CupertinoIcons.calendar,
                        color: CupertinoColors.systemGrey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: CupertinoColors.systemGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ComingSoon(comingSoon: comingSoon),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

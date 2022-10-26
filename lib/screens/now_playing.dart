import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/constants.dart';
import 'movie_details.dart';
import 'dart:developer';

class NowPlaying extends StatelessWidget {
  const NowPlaying({
    Key? key,
    required this.nowPlaying,
  }) : super(key: key);

  final List nowPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nowPlaying == null ? 0 : (nowPlaying.length > 10 ? 10 : nowPlaying.length),
        itemBuilder: (context, index) {
          nowPlaying.removeWhere((item) => nowPlaying[index]['poster_path'] == null);
          return InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => FullMovieDetails(
                    movieID: nowPlaying[index]['id'].toString(),
                    movieTitle: nowPlaying[index]['title'],
                    moviePoster: Constants.imageBaseUrl + nowPlaying[index]['poster_path'],
                    movieReleaseDate: nowPlaying[index]['release_date'],
                    movieDesc: nowPlaying[index]['overview'],
                    movieRating: double.parse((nowPlaying[index]['vote_average']).toStringAsFixed(1)),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Container(
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: NetworkImage(Constants.imageBaseUrl + nowPlaying[index]['poster_path']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

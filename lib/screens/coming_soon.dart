import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/constants.dart';
import 'movie_details.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({
    Key? key,
    required this.comingSoon,
  }) : super(key: key);

  final List comingSoon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, bottom: 20),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: comingSoon == null ? 0 : (comingSoon.length > 10 ? 10 : comingSoon.length),
        itemBuilder: (context, index) {
          comingSoon.removeWhere((item) => comingSoon[index]['poster_path'] == null);
          return InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => FullMovieDetails(
                    movieID: comingSoon[index]['id'].toString(),
                    movieTitle: comingSoon[index]['title'],
                    moviePoster: Constants.imageBaseUrl + comingSoon[index]['poster_path'],
                    movieReleaseDate: comingSoon[index]['release_date'],
                    movieDesc: comingSoon[index]['overview'],
                    movieRating: double.parse((comingSoon[index]['vote_average']).toStringAsFixed(1)),
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
                    image: NetworkImage(Constants.imageBaseUrl + comingSoon[index]['poster_path']),
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
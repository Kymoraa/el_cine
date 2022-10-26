import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/constants.dart';
import 'movie_details.dart';

class TopRated extends StatelessWidget {
  const TopRated({
    Key? key,
    required this.topRated,
  }) : super(key: key);

  final List topRated;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topRated == null ? 0 : (topRated.length > 10 ? 10 : topRated.length),
        itemBuilder: (context, index) {
          topRated.removeWhere((item) => topRated[index]['poster_path'] == null);
          return InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => FullMovieDetails(
                    movieID: topRated[index]['id'].toString(),
                    movieTitle: topRated[index]['title'],
                    moviePoster: Constants.imageBaseUrl + topRated[index]['poster_path'],
                    movieReleaseDate: topRated[index]['release_date'],
                    movieDesc: topRated[index]['overview'],
                    movieRating: double.parse((topRated[index]['vote_average']).toStringAsFixed(1)),
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
                    image: NetworkImage(Constants.imageBaseUrl + topRated[index]['poster_path']),
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
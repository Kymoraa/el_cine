import 'package:dots_indicator/dots_indicator.dart';
import 'package:el_cine/theme/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/constants.dart';
import 'dart:developer';
import 'movie_details.dart';

class TrendingMovie extends StatefulWidget {
  const TrendingMovie({
    Key? key,
    required this.trendingMovies,
  }) : super(key: key);

  final List trendingMovies;

  @override
  State<TrendingMovie> createState() => _TrendingMovieState();
}

class _TrendingMovieState extends State<TrendingMovie> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = 300;

  String movieDesc = '';

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 450,
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.trendingMovies == null
                ? 0
                : (widget.trendingMovies.length > 7 ? 7 : widget.trendingMovies.length),
            itemBuilder: (context, position) {
              return _trendingItemsWidget(position);
            },
          ),
        ),
        const SizedBox(height: 10.0),
        DotsIndicator(
          dotsCount: 7,
          position: _currPageValue,
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeColor: CupertinoColors.activeOrange,
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }

  Widget _trendingItemsWidget(int index) {
    movieDesc = widget.trendingMovies[index]['overview'];
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale = _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      var currTrans = _height * (1 - _scaleFactor) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(1, currTrans, 1);
    }

    return Transform(
      transform: matrix,
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => FullMovieDetails(
                movieID: widget.trendingMovies[index]['id'].toString(),
                movieTitle: widget.trendingMovies[index]['title'],
                moviePoster: Constants.imageBaseUrl + widget.trendingMovies[index]['poster_path'],
                movieReleaseDate: widget.trendingMovies[index]['release_date'],
                movieDesc: widget.trendingMovies[index]['overview'],
                movieRating: widget.trendingMovies[index]['vote_average']),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(16),
          height: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: DecorationImage(
              image: NetworkImage(Constants.imageBaseUrl + widget.trendingMovies[index]['backdrop_path']),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                Colors.black26,
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                height: 25,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: CupertinoColors.systemOrange,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: CupertinoColors.white, size: 13),
                    Text(
                      (widget.trendingMovies[index]['vote_average']).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.trendingMovies[index]['title'],
                style: context.headline5.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                movieDesc.length > 100 ? '${movieDesc.substring(0, 100)}...' : movieDesc,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import '../api/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:developer';

class MovieReviews extends StatefulWidget {
  const MovieReviews({
    Key? key,
    required this.movieID,
  }) : super(key: key);
  final String movieID;

  @override
  State<MovieReviews> createState() => _MovieReviewsState();
}

class _MovieReviewsState extends State<MovieReviews> with TickerProviderStateMixin {
  List movieReviews = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late AnimationController controller;

  Future<void> _getMovieReviews() async {
    final url = Uri.parse(Constants.baseUrl + widget.movieID + Constants.movieReviews);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movieReviews = data.values.toList()[2];
      });
    } else {
      throw Exception('Failed to load reviews.');
    }
  }

  void _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _getMovieReviews();
    });
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _getMovieReviews();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CircularProgressIndicator(value: controller.value);
    if (movieReviews.isEmpty) {
      return const Center(
        child: Text(
          'No reviews to display',
          style: TextStyle(color: CupertinoColors.systemOrange),
        ),
      );
    } else {
      return Scaffold(
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          //onLoading: _onLoading,
          enablePullDown: true,
          enablePullUp: true,
          header: const WaterDropHeader(),
          child: ListView.separated(
            itemCount: movieReviews.length,
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: (movieReviews[index]['author_details']['avatar_path'] != null && (Uri.parse(movieReviews[index]['author_details']['avatar_path'].substring(1, movieReviews[index]['author_details']['avatar_path'].length)).isAbsolute) != true)
                          ? NetworkImage(Constants.imageBaseUrl + movieReviews[index]['author_details']['avatar_path'])
                          : (movieReviews[index]['author_details']['avatar_path'] != null && Uri.parse(movieReviews[index]['author_details']['avatar_path'].substring(1, movieReviews[index]['author_details']['avatar_path'].length)).isAbsolute) != false
                          ? NetworkImage(movieReviews[index]['author_details']['avatar_path'].substring(1, movieReviews[index]['author_details']['avatar_path'].length))
                          : const AssetImage('assets/images/avatar_unavailable.png') as ImageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                title: ReadMoreText(
                  movieReviews[index]['content'],
                  trimLines: 5,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: ' Show less',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                ),
                subtitle: Text(
                  movieReviews[index]['author'],
                  style: const TextStyle(fontSize: 13),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      );
    }
  }
}

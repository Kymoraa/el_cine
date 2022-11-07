import 'package:el_cine/screens/lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/constants.dart';
import 'dart:convert';
import '../utils/lists_shared_prefs.dart';

class AboutMovie extends StatefulWidget  {
  const AboutMovie({
    Key? key,
    required this.movieID,
    required this.moviePoster,
    required this.movieReleaseDate,
    required this.movieDesc,
    required this.movieRating,
  }) : super(key: key);

  final String movieID;
  final String moviePoster;
  final String movieReleaseDate;
  final String movieDesc;
  final double movieRating;

  @override
  State<AboutMovie> createState() => _AboutMovieState();
}

class _AboutMovieState extends State<AboutMovie>{
  List<String> moviesListed = [];
  List movieCredits = [];
  List fullMovieDetails = [];
  List movieTrailer = [];
  String genre = '';
  String movieID = '';
  String castImageUrl = '';
  bool movieListedFlag = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getMovieCredits() async {
    final url = Uri.parse(Constants.baseUrl + widget.movieID + Constants.movieCredits);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movieCredits = data.values.toList()[1];
      });
    } else {
      throw Exception('Failed to load movie credits.');
    }
  }

  Future<void> _getFullMovieDetails() async {
    final url = Uri.parse(Constants.baseUrl + widget.movieID + Constants.apiKey);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        fullMovieDetails = data.values.toList();
        genre = [for (var data in fullMovieDetails[4]) data['name']].join(" | ");
        movieID = fullMovieDetails[6].toString();
      });
    } else {
      throw Exception('Failed to load full movie details.');
    }
  }

  Future<void> _getMovieTrailer() async {
    final url = Uri.parse(Constants.baseUrl + widget.movieID + Constants.movieVideos);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movieTrailer = data.values.toList()[1];
      });
    } else {
      throw Exception('Failed to load movie videos.');
    }
  }

  Future _getSharedPrefs() async {
    moviesListed = ListSharedPrefs.getMovieList() ?? [];
    if (moviesListed.isNotEmpty) {
      for (var index = 0; index < moviesListed.length; index++) {
        if (moviesListed.contains(movieID)) {
          movieListedFlag = true;
        } else {
          movieListedFlag = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([_getSharedPrefs(), _getMovieCredits(), _getFullMovieDetails(), _getMovieTrailer()]),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20.0, left: 20, bottom: 20),
                      width: 170,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: widget.moviePoster != 'null'
                              ? NetworkImage(widget.moviePoster)
                              : const AssetImage('assets/images/poster_unavailable.png') as ImageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  widget.movieRating.toStringAsFixed(1),
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
                          Row(
                            children: [
                              const Text(
                                'Release Date: ',
                                style: TextStyle(fontSize: 13.0),
                              ),
                              Text(
                                widget.movieReleaseDate,
                                style: const TextStyle(fontSize: 13.0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 150,
                            child: Text(
                              genre,
                              style: const TextStyle(fontSize: 13.0, color: CupertinoColors.systemGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent.withOpacity(0.1),
                          side: const BorderSide(
                            width: 2,
                            color: CupertinoColors.systemOrange,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Watch Trailer',
                          style: TextStyle(color: CupertinoColors.systemOrange, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          movieListedFlag
                              ? CupertinoIcons.plus_rectangle_fill_on_rectangle_fill
                              : CupertinoIcons.plus_rectangle_on_rectangle,
                          color: movieListedFlag ? CupertinoColors.systemOrange : CupertinoColors.systemGrey,
                          size: 20,
                        ),
                        onPressed: () async {
                          if (moviesListed.contains(widget.movieID)) {
                            setState(() {
                              moviesListed.remove(widget.movieID); // remove movie from myList if ID was added before
                              ListSharedPrefs.setMovieList(moviesListed);
                              Lists();
                            });
                          } else {
                            setState(() {
                              moviesListed.add(widget.movieID);
                              ListSharedPrefs.setMovieList(moviesListed);
                            });
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          CupertinoIcons.reply,
                          color: CupertinoColors.systemGrey,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: const Text(
                        'Synopsis',
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        widget.movieDesc,
                        style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: const Text(
                        'Cast',
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, bottom: 20),
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movieCredits == null ? 0 : (movieCredits.length > 10 ? 10 : movieCredits.length),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(left: 10, top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),
                                      image: DecorationImage(
                                        image: movieCredits[index]['profile_path'] != null
                                            ? NetworkImage(Constants.imageBaseUrl + movieCredits[index]['profile_path'])
                                            : const AssetImage('assets/images/img_1.png') as ImageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    movieCredits[index]['character'],
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                  Text(
                                    movieCredits[index]['name'],
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      color: CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


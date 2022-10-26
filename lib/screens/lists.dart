import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/lists_shared_prefs.dart';
import 'package:http/http.dart' as http;
import '../api/constants.dart';
import 'dart:convert';

import 'movie_details.dart';

class Lists extends StatefulWidget {
  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  late final _fetchList = _getMoviesInList();
  List<String> moviesListed = [];
  List fullMovieDetails = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.refresh,
              size: 22.0,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Oops we had trouble loading your list',
                    style: TextStyle(color: CupertinoColors.systemOrange),
                  ),
                );
              }
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (120.0 / 185.0),
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => FullMovieDetails(
                              movieID: fullMovieDetails[index][6].toString(),
                              movieTitle: fullMovieDetails[index][21],
                              moviePoster: Constants.imageBaseUrl + fullMovieDetails[index][12],
                              movieReleaseDate: fullMovieDetails[index][15],
                              movieDesc: fullMovieDetails[index][10],
                              movieRating: double.parse((fullMovieDetails[index][23]).toStringAsFixed(1)),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: NetworkImage(Constants.imageBaseUrl + snapshot.data?[index][12]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No movies in lists',
                    style: TextStyle(color: CupertinoColors.systemOrange),
                  ),
                );
              }
            default:
              return Center(
                child: Column(
                  children: const <Widget>[
                    Text(
                      'Loading your movies list',
                      style: TextStyle(color: CupertinoColors.systemOrange),
                    ),
                    SizedBox(height: 32),
                    CircularProgressIndicator(),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Future<List> _getMoviesInList() async {
    moviesListed = ListSharedPrefs.getMovieList() ?? [];
    if (moviesListed.isNotEmpty) {
      for (var index = 0; index < moviesListed.length; index++) {
        final url = Uri.parse(Constants.baseUrl + moviesListed[index] + Constants.apiKey);
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          fullMovieDetails.add(data.values.toList());
        } else {
          throw Exception('Failed to load full movie details.');
        }
      }
    } else {
      print('No list to display');
    }
    return fullMovieDetails;
  }
}

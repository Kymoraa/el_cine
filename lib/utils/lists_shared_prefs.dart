import 'package:shared_preferences/shared_preferences.dart';

class ListSharedPrefs {
  static late SharedPreferences _preferences;
  static const _keyMoviesListed = "movieList";
  static const _keyMoviesBool = "movieBool";
  static bool movieIsListed = false;

  static Future init () async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setMovieList (List<String> moviesListed) async {
    await _preferences.setStringList(_keyMoviesListed, moviesListed);
  }

  static List<String>? getMovieList () => _preferences.getStringList(_keyMoviesListed);

  static Future setMovieBool (bool movieIsListed) async {
    await _preferences.setBool(_keyMoviesBool, movieIsListed);
  }

  static bool? getMovieBool () => _preferences.getBool(_keyMoviesBool);
}
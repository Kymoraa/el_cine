import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieThemeDark {
  MovieThemeDark._();

  static ThemeData get theme => ThemeData(
    primaryColor: const Color(0xffffffff),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.black,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xffffffff),
    ),
    textTheme: textTheme,
  );

  static TextTheme get textTheme {
    return TextTheme(
      caption: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      subtitle1: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      subtitle2: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyText1: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyText2: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headline6: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline5: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline4: GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline3: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline2: GoogleFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline1: GoogleFonts.montserrat(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}

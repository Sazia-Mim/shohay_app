import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shohay_app/theme/color_constants.dart';

final Map<int, Color> _yellow700Map = {
  50: const Color(0xFFFFD7C2),
  100: Colors.yellow[100]!,
  200: Colors.yellow[200]!,
  300: Colors.yellow[300]!,
  400: Colors.yellow[400]!,
  500: Colors.yellow[500]!,
  600: Colors.yellow[600]!,
  700: Colors.yellow[800]!,
  800: Colors.yellow[900]!,
  900: Colors.yellow[700]!,
};

final MaterialColor _yellow700Swatch =
    MaterialColor(Colors.yellow[700]!.value, _yellow700Map);

class ShohayAppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: _yellow700Swatch,
      dividerColor: kGreyColor800,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: GoogleFonts.lato().fontFamily,
      textTheme: TextTheme(
        headline1: const TextStyle(
          color: kBlackColor900,
          fontSize: 34,
          fontWeight: FontWeight.w400,
        ),
        headline2: const TextStyle(
          color: kBlackColor900,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headline3: const TextStyle(
          color: kBlackColor900,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        headline4: const TextStyle(
          color: kBlackColor900,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(
          color: kGreyColor800,
          fontSize: 14,
          fontFamily: GoogleFonts.sourceSansPro().fontFamily,
          fontWeight: FontWeight.w500,
        ),
        headline6: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        bodyText1: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        bodyText2: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

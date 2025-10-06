import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color primary = Colors.deepOrange;
  static final Color scaffoldBg = const Color(0xFFF7F7FB);

  static final ThemeData lightTheme = ThemeData(
    // primaryColor: primary,
    // scaffoldBackgroundColor: scaffoldBg,
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Colors.white,
    //   elevation: 0,
    //   centerTitle: false,
    // ),
    // visualDensity: VisualDensity.adaptivePlatformDensity,

    // 👇 Apply Plus Jakarta Sans globally
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w300, // Light 300 as default body
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w300,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w600, // slightly bolder for AppBar titles
      ),
    ),
  );
}

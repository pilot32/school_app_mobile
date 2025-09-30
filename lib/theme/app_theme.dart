import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = Colors.deepOrange;
  static final Color scaffoldBg = const Color(0xFFF7F7FB);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: scaffoldBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

import 'package:flutter/material.dart';

class AppTheme {
  static const Color red = Color(0xFFE0322F);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        primaryColor: red,
        colorScheme: const ColorScheme.dark(
          primary: red,
          secondary: red,
          surface: surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          elevation: 0,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: red,
          thumbColor: red,
          inactiveTrackColor: Color(0xFF3A3A3A),
        ),
      );
}

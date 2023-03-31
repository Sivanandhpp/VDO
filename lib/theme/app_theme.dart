// // ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF3F4F3),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF171585),
      secondary: Color(0xFF0DA7FF),
      
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xDD000000),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF171585),
      secondary: Color(0xFF0DA7FF),
    ),
  );
}

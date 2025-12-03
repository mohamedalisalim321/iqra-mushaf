import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFF4E9D8),
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFF4E9D8),
    primary: Color(0xFF7A5C3A),
    secondary: Color(0xFFD1A85A),
    onSurface: Color(0xFF3B2F2F),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),
);

ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF2C241E),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF3A2F26),
    primary: Color(0xFFBFA476),
    secondary: Color(0xFFD1A85A),
    onSurface: Color(0xFFF2E4C7),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
  ),
);

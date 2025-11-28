import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color.fromRGBO(245, 250, 240, 1),
    secondary: Color.fromRGBO(30, 136, 34, 1),
    primary: Color.fromRGBO(21, 101, 26, 1),
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 41, 41, 41),
    secondary: Color.fromRGBO(30, 136, 34, 1),
    primary: Color.fromRGBO(21, 101, 26, 1),
  ),
);

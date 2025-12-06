import 'package:flutter/material.dart';

// -------------------------------------------
// PREMIUM COLOR PALETTE
// -------------------------------------------

// Golds
const _goldLight = Color(0xFFE8C57A);
const _goldDeep = Color(0xFFD6A84F);

// Browns
const _brownDeep = Color(0xFF4A3825);

// Parchment
const _parchmentLight = Color(0xFFF9F5EB);
const _parchmentSurface = Color(0xFFFFFCF7);
const _parchmentCard = Color(0xFFF2E9D9); // gentle card surface

// Dark mode
const _nightDeep = Color(0xFF18130F);
const _nightSurface = Color(0xFF221D18);
const _nightOverlay = Color(0xFF2D2721); // mid-layer
const _nightAccent = Color(0xFFC6B089);
const _nightText = Color(0xFFF4ECD8);

/// -------------------------------------------
///  LIGHT MODE THEME (Mushaf Premium)
// -------------------------------------------
final ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: _parchmentLight,
  colorScheme: const ColorScheme.light(
    primary: _goldDeep,
    onPrimary: Colors.white,
    secondary: _goldLight,
    onSecondary: Colors.white,
    surface: _parchmentSurface,
    onSurface: _brownDeep,
    shadow: Colors.black54,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _goldLight,
    shadowColor: Colors.black26,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: _brownDeep,
      fontWeight: FontWeight.w700,
    ),
  ),
  cardColor: _parchmentCard,
  dividerColor: Colors.black26,
  splashColor: _goldDeep.withOpacity(0.15),
  highlightColor: _goldDeep.withOpacity(0.07),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: _goldDeep,
    selectionHandleColor: _goldDeep,
  ),
  shadowColor: Colors.black26,
);

/// -------------------------------------------
///  DARK MODE THEME (Midnight Gold Premium)
// -------------------------------------------
final ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _nightDeep,
  colorScheme: const ColorScheme.dark(
    primary: _nightAccent, // elegant gold
    onPrimary: Colors.black,
    secondary: _goldDeep,
    onSecondary: Colors.black,
    surface: _nightSurface,
    onSurface: _nightText,
    shadow: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _nightSurface,
    shadowColor: Colors.black54,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: _nightText,
      fontWeight: FontWeight.w700,
    ),
  ),
  cardColor: _nightOverlay,
  dividerColor: Colors.white24,
  splashColor: _nightAccent.withOpacity(0.15),
  highlightColor: _nightAccent.withOpacity(0.08),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: _nightAccent,
    selectionHandleColor: _nightAccent,
  ),
  shadowColor: Colors.black54,
);

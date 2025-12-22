import 'package:flutter/material.dart';

// -------------------------------------------
// PREMIUM COLOR PALETTE (Enhanced)
// -------------------------------------------

// Golds
const _goldLight = Color(0xFFE2C178); // Softer antique gold
const _goldDeep = Color(0xFFCFA24A); // Deeper, calmer gold (less harsh)

// Browns
const _brownDeep = Color(0xFF3F2E1D); // Warmer, ink-like brown

// Parchment
const _parchmentLight = Color(0xFFF7F2E7); // Aged parchment feel
const _parchmentSurface = Color(0xFFFCF9F2); // Clean paper surface
const _parchmentCard = Color(0xFFF0E6D3); // Subtle separation for card

// Dark mode
const _nightDeep = Color(0xFF14110E); // True deep night (AMOLED friendly)
const _nightSurface = Color(0xFF1E1A16); // Soft elevation surface
const _nightOverlay = Color(0xFF29241F); // Card & overlay separation
const _nightAccent = Color(0xFFC2AB78); // Muted antique gold
const _nightText = Color(0xFFF1E9D6); // Warm off-white (no glare)

/// -------------------------------------------
///  LIGHT MODE THEME (Mushaf Premium)
// -------------------------------------------
final ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: _parchmentLight,
  colorScheme: const ColorScheme.light(
    primary: _goldDeep, // Primary color for buttons, highlights
    onPrimary: Colors.white, // Text color on primary
    secondary: _goldLight, // Secondary accents
    onSecondary: Colors.white,
    surface: _parchmentSurface, // Background for cards, surfaces
    onSurface: Colors.black, // Text color on surface
    shadow: Colors.black54, // General shadow color
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _goldLight,
    shadowColor: Colors.black26,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: _brownDeep, // Text color in the app bar
      fontWeight: FontWeight.w700,
    ),
  ),
  cardColor: _parchmentCard, // Light card surface
  dividerColor: Colors.black26, // Divider color for UI elements
  splashColor: _goldDeep.withOpacity(0.15),
  highlightColor: _goldDeep.withOpacity(0.07),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: _goldDeep, // Cursor color in text fields
    selectionHandleColor: _goldDeep, // Selection handle color
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
    primary: _nightAccent, // Elegant gold for highlights and buttons
    onPrimary: Colors.black, // Text on primary elements
    secondary: _goldDeep, // Secondary accents
    onSecondary: Colors.black, // Text on secondary elements
    surface: _nightSurface, // Surface color for cards, content areas
    onSurface: Colors.white, // Text color on surfaces
    shadow: Colors.black, // General shadow color for dark mode
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _nightSurface,
    shadowColor: Colors.black54,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: _nightText, // Title text color in the app bar
      fontWeight: FontWeight.w700,
    ),
  ),
  cardColor: _nightOverlay, // Card background color
  dividerColor: Colors.white24, // Divider color in dark mode
  splashColor: _nightAccent.withOpacity(0.15),
  highlightColor: _nightAccent.withOpacity(0.08),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: _nightAccent, // Cursor color in text fields
    selectionHandleColor: _nightAccent, // Selection handle color
  ),
  shadowColor: Colors.black54,
);

import 'package:flutter/material.dart';

// -------------------------------------------
// PREMIUM COLOR PALETTE (Enhanced)
// -------------------------------------------

// Golds
const _goldLight = Color(0xFFE8C57A); // Soft, warm gold
const _goldDeep = Color(0xFFD6A84F); // Rich gold, deeper tone

// Browns
const _brownDeep = Color(0xFF4A3825); // Deep brown for text and subtle surfaces

// Parchment
const _parchmentLight = Color(0xFFF9F5EB); // Soft parchment background
const _parchmentSurface =
    Color(0xFFFFFCF7); // Surface color for cards or background
const _parchmentCard =
    Color(0xFFF2E9D9); // Gentle card surface color for soft contrast

// Dark mode
const _nightDeep = Color(0xFF18130F); // Deep dark background for dark mode
const _nightSurface = Color(0xFF221D18); // Dark surface color for content areas
const _nightOverlay =
    Color(0xFF2D2721); // Overlay for layers, soft mid-darkness
const _nightAccent = Color(0xFFC6B089); // Elegant gold for accents
const _nightText = Color(0xFFF4ECD8); // Off-white text color for readability

// Sepia Mode
const _sepiaBackground = Color(0xFFF0E1D6); // Soft sepia background color
const _sepiaSurface = Color(0xFFDBC6A7); // Surface color for content areas
const _sepiaCard = Color(0xFFE2D5B7); // Card background with sepia tint
const _sepiaAccent = Color(0xFFBC9D6B); // Sepia gold for accents
const _sepiaText = Color(0xFF4E3B31); // Text color for sepia (dark brown)
const _sepiaSecondary =
    Color(0xFF9C7A57); // Secondary sepia tones for highlights

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
    onSurface: _brownDeep, // Text color on surface
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
    onSurface: _nightText, // Text color on surfaces
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

/// -------------------------------------------
///  SEPIA MODE THEME (Vintage Sepia Premium)
// -------------------------------------------
final ThemeData sepiaMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light, // Sepia usually has a softer, light vibe
  scaffoldBackgroundColor: _sepiaBackground,
  colorScheme: const ColorScheme.light(
    primary: _sepiaAccent, // Sepia gold for primary actions
    onPrimary: Colors.white, // Text on primary elements
    secondary: _sepiaSecondary, // Secondary sepia tones for accents
    onSecondary: Colors.white,
    surface: _sepiaSurface, // Background for cards and content areas
    onSurface: _sepiaText, // Text color on surface (dark brown)
    shadow: Colors.black54, // Subtle shadow
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _sepiaSurface,
    shadowColor: Colors.black26,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: _sepiaText, // Title text color in the app bar
      fontWeight: FontWeight.w700,
    ),
  ),
  cardColor: _sepiaCard, // Soft sepia color for cards
  dividerColor: Colors.black26, // Divider color for UI elements
  splashColor: _sepiaAccent.withOpacity(0.15),
  highlightColor: _sepiaAccent.withOpacity(0.07),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: _sepiaAccent, // Cursor color in text fields
    selectionHandleColor: _sepiaAccent, // Selection handle color
  ),
  shadowColor: Colors.black26,
);

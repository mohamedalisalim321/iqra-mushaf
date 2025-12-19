import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';

/// Enum for future-proofing (you can add more themes later)
enum AppTheme { light, dark, sepia }

class ThemeProvider extends ChangeNotifier {
  static const _prefKey = 'app_theme';
  late SharedPreferences _prefs;

  /// Current theme mode
  AppTheme _currentTheme = AppTheme.light;

  /// Getter for the current theme mode
  AppTheme get currentTheme => _currentTheme;

  /// Getter for actual theme data based on selected theme
  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.dark:
        return darkMode;
      case AppTheme.light:
        return lightMode;
      case AppTheme.sepia:
        return sepiaMode;
      default:
        return lightMode;
    }
  }

  /// Convenient boolean for checking if it’s dark mode
  bool get isDarkMode => _currentTheme == AppTheme.dark;

  /// Constructor initializes stored theme and loads preferences
  ThemeProvider() {
    _initialize();
  }

  /// Initializes SharedPreferences and loads the current theme
  Future<void> _initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _loadTheme();
    } catch (e) {
      print("Error initializing preferences: $e");
      // Fallback to light theme if error occurs
      _currentTheme = AppTheme.light;
    }
  }

  /// Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    final themeIndex = _prefs.getInt(_prefKey);
    if (themeIndex != null && themeIndex < AppTheme.values.length) {
      _currentTheme = AppTheme.values[themeIndex];
    }
    notifyListeners(); // Notify listeners only after loading theme
  }

  /// Save theme to SharedPreferences
  Future<void> _saveTheme() async {
    try {
      await _prefs.setInt(_prefKey, _currentTheme.index);
    } catch (e) {
      print("Error saving theme: $e");
    }
  }

  /// Change theme explicitly
  Future<void> setTheme(AppTheme theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      await _saveTheme();
      notifyListeners();
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_currentTheme == AppTheme.light) {
      _currentTheme = AppTheme.dark;
    } else {
      _currentTheme = AppTheme.light;
    }
    await _saveTheme();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';

/// Enum for future-proofing (you can add more themes later)
enum AppTheme { light, dark }

class ThemeProvider extends ChangeNotifier {
  static const _prefKey = 'app_theme';

  /// Current theme mode
  AppTheme _currentTheme = AppTheme.light;

  /// Getter
  AppTheme get currentTheme => _currentTheme;

  /// Expose the actual theme
  ThemeData get themeData =>
      _currentTheme == AppTheme.dark ? darkMode : lightMode;

  /// Convenient boolean toggle
  bool get isDarkMode => _currentTheme == AppTheme.dark;

  /// Constructor initializes stored theme
  ThemeProvider() {
    _loadTheme();
  }

  /// Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_prefKey);

    if (themeIndex != null && themeIndex < AppTheme.values.length) {
      _currentTheme = AppTheme.values[themeIndex];
      notifyListeners();
    }
  }

  /// Save theme to local storage
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, _currentTheme.index);
  }

  /// Change theme explicitly
  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    await _saveTheme();
    notifyListeners();
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    _currentTheme =
        _currentTheme == AppTheme.light ? AppTheme.dark : AppTheme.light;

    await _saveTheme();
    notifyListeners();
  }
}

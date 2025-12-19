import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings with ChangeNotifier {
  // --- Constants ---
  static const String _kDefaultFont = 'Lateef';
  static const String _kDefaultEngFont = 'Lora';
  static const double _kDefaultFontSize = 18.0;
  static const List<String> _kAvailableArabicFonts = [
    'Kufi',
    'Cairo',
    'Lateef'
  ];

  static const List<String> _kAvailableEngFonts = ['Lora', 'Raleway'];

  // --- Private storage ---
  String _currentFont = _kDefaultFont;
  String _currentEngFont = _kDefaultEngFont;
  double _arabicFontSize = _kDefaultFontSize;

  // --- Public getters (scaled via ScreenUtil) ---
  String get currentFont => _currentFont;
  String get currentEngFont => _currentEngFont;
  double get arabicFontSize => _arabicFontSize.sp;

  // --- Font list (immutable) ---
  List<String> get fontsList => List.unmodifiable(_kAvailableArabicFonts);
  List<String> get fontsEngList => List.unmodifiable(_kAvailableEngFonts);

  // --- Constructor with async initializer ---
  AppSettings._internal();

  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentFont = prefs.getString('_currentFont') ?? _kDefaultFont;
    _arabicFontSize = prefs.getDouble('_arabicFontSize') ?? _kDefaultFontSize;
    _currentEngFont = prefs.getString("_currentEngFont") ?? _kDefaultEngFont;
    // Ensure loaded font is valid
    if (!_kAvailableArabicFonts.contains(_currentFont)) {
      _currentFont = _kDefaultFont;
    }
    // Clamp font size to reasonable range
    _arabicFontSize = _arabicFontSize;
  }

  // --- Font setter with validation & persistence ---
  Future<void> changeCurrentFont(String newFont) async {
    if (!_kAvailableArabicFonts.contains(newFont) || newFont == _currentFont) {
      return;
    }

    _currentFont = newFont;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_currentFont', newFont);
  }

  Future<void> changeCurrentEngFont(String newFont) async {
    if (!_kAvailableEngFonts.contains(newFont) || newFont == _currentEngFont) {
      return;
    }

    _currentEngFont = newFont;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_currentEngFont', newFont);
  }

  // --- Font size setter with clamping & persistence ---
  Future<void> changeArabicFontSize(double newValue) async {
    // Clamp to safe range and round to avoid floating-point noise
    final clamped = newValue.roundToDouble();
    if (clamped == _arabicFontSize) return;

    _arabicFontSize = clamped;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('_arabicFontSize', clamped);
  }

  // --- Reset to defaults with persistence ---
  Future<void> resetSettings() async {
    _currentFont = _kDefaultFont;
    _arabicFontSize = _kDefaultFontSize;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_currentFont', _kDefaultFont);
    await prefs.setString('_currentEngFont', _kDefaultEngFont);
    await prefs.setDouble('_arabicFontSize', _kDefaultFontSize);
  }
}

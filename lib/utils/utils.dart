import 'package:flutter/material.dart';

/// Arabic digits map for converting English digits to Arabic digits.
const Map<String, String> _arabicDigits = {
  "0": "٠",
  "1": "١",
  "2": "٢",
  "3": "٣",
  "4": "٤",
  "5": "٥",
  "6": "٦",
  "7": "٧",
  "8": "٨",
  "9": "٩",
};

/// Extension on String to convert all English digits to Arabic digits.
extension ArabicDigitsStringExtension on String {
  String toArabicDigits() {
    return this.replaceAllMapped(RegExp(r'[0-9]'), (match) {
      return _arabicDigits[match.group(0)!] ?? match.group(0)!;
    });
  }
}

/// Extension on num to convert all English digits to Arabic digits.
extension ArabicDigitsNumExtension on num {
  String toArabicDigits() => this.toString().toArabicDigits();
}

/// Helper function to convert an integer to Arabic digits.
String convertToArabicNumber(int number) => number.toArabicDigits();

/// Parses Arabic text and colors the specific patterns.
/// ( ... )   → RED
/// ﴿ ... ﴾   → GREEN
/// { ... }   → BLUE
List<TextSpan> parseArabicText(String text) {
  final List<TextSpan> spans = [];
  final pattern = RegExp(
      r'(\(.*?\)|﴿.*?﴾|{.*?})'); // Regex pattern to match specific segments

  final matches = pattern.allMatches(text);
  int lastIndex = 0;

  // Iterate over all matches and create the appropriate TextSpan elements
  for (final match in matches) {
    if (match.start > lastIndex) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex, match.start),
          style: const TextStyle(color: Colors.black),
        ),
      );
    }

    final matched = match.group(0)!;

    // Define color based on the start character of the match
    Color color;
    if (matched.startsWith('(')) {
      color = Colors.red;
    } else if (matched.startsWith('﴿')) {
      color = Colors.green;
    } else if (matched.startsWith('{')) {
      color = Colors.blue;
    } else {
      color = Colors.black;
    }

    spans.add(
      TextSpan(
        text: matched,
        style: TextStyle(color: color),
      ),
    );

    lastIndex = match.end;
  }

  // Add remaining text after the last match
  if (lastIndex < text.length) {
    spans.add(
      TextSpan(
        text: text.substring(lastIndex),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  return spans;
}

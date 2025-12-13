import 'package:flutter/material.dart';

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

extension ArabicDigitsStringExtension on String {
  String toArabicDigits() {
    return split('').map((char) => _arabicDigits[char] ?? char).join();
  }
}

extension ArabicDigitsNumExtension on num {
  String toArabicDigits() => toString().toArabicDigits();
}

String convertToArabicNumber(int number) => number.toArabicDigits();

List<TextSpan> parseArabicText(String text) {
  final List<TextSpan> spans = [];

  // ( ... )   → RED
  // ﴿ ... ﴾   → GREEN
  // { ... }   → BLUE
  final pattern = RegExp(r'(\(.*?\)|﴿.*?﴾|{.*?})');

  final matches = pattern.allMatches(text);

  int lastIndex = 0;

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

    if (matched.startsWith('(')) {
      spans.add(
        TextSpan(
          text: matched,
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else if (matched.startsWith('﴿')) {
      spans.add(
        TextSpan(
          text: matched,
          style: const TextStyle(color: Colors.green),
        ),
      );
    } else if (matched.startsWith('{')) {
      spans.add(
        TextSpan(
          text: matched,
          style: const TextStyle(color: Colors.blue),
        ),
      );
    }

    lastIndex = match.end;
  }

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

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

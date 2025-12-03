const Map<String, String> _arabicNumbers = {
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

extension ArabicNumberExtension on num {
  String toArabicNumber() {
    final str = toString();

    return str.split("").map((char) {
      // Keep non-digit characters (minus sign, decimal point, etc.)
      return _arabicNumbers[char] ?? char;
    }).join();
  }
}

convertToArabicNumber(int index) {
  final digits = index.toString().split("");
  final arabicNumeric =
      digits.map((digit) => _arabicNumbers[digit] ?? digit).join();
  return arabicNumeric;
}

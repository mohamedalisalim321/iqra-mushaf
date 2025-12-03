import 'dart:io';

void main() {
  final input = File('quran_pages.dart').readAsStringSync();

  // Remove newlines and extra spaces
  final compressed = input
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll('\n', '')
      .replaceAll('\t', '')
      .replaceAll(' ,', ',')
      .replaceAll(', ', ',');

  File('quran_pages_compressed.dart').writeAsStringSync(compressed);

  print('Compression complete!');
}

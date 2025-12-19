import 'range.dart';
import 'verse.dart';

class PageData {
  final List<Range> ranges;
  final Map<String, Verse> verses;
  final String font;
  final List<String> surahsNames;

  PageData(
    this.ranges,
    this.verses,
    this.font,
    this.surahsNames,
  );
}

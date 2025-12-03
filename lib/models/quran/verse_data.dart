import 'package:isar/isar.dart';

part 'verse_data.g.dart';

@collection
class VerseData {
  Id id = Isar.autoIncrement;

  @Index()
  late int surahNumber;

  @Index()
  late int verseNumber;

  @Index()
  late int wordNumber;

  @Index(caseSensitive: false)
  late String sarf;

  @Index(caseSensitive: false)
  late String irab;

  @Index(caseSensitive: false)
  late String wordMeaning;
}

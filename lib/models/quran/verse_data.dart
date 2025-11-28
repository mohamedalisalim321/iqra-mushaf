import 'package:isar/isar.dart';

part 'verse_data.g.dart';

@collection
class VerseData {
  Id id = Isar.autoIncrement;

  late int surahNumber;
  late int verseNumber;
  late int wordNumber;

  late String sarf;
  late String irab;
  late String wordMeaning;
}

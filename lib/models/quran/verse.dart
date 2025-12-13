import 'package:isar/isar.dart';

part 'verse.g.dart';

@collection
class Verse {
  Id id = Isar.autoIncrement;

  @Index()
  late int surahNumber;
  @Index()
  late int verseNumber;
  // @Index()
  // late int verseIndex;

  @Index(caseSensitive: false)
  late String surahName;

  late String qcfData;
  late String qcfV4Data;

  late String verseText;
  late String normalVerse;
}

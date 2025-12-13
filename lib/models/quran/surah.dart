import 'package:isar/isar.dart';

import 'verse.dart';

part 'surah.g.dart';

@collection
class Surah {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false)
  late String surahName;

  @Index(caseSensitive: false)
  late String surahNameTr;

  @Index(caseSensitive: false)
  late String surahType;

  @Index(unique: true)
  late int surahIndex;

  @Index()
  late int versesCount;

  late int words;
  late int letters;
  late int revelationOrder;

  late int firstPage;
  late int lastPage;

  final verses = IsarLinks<Verse>();
}

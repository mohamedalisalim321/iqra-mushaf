import 'package:isar/isar.dart';

import 'verse.dart';

part 'surah.g.dart';

@collection
class Surah {
  Id id = Isar.autoIncrement;
  late String surahName;
  late String surahNameTr;
  late String surahType;

  @Index(unique: true)
  late int surahIndex;

  late int versesCount;
  late int words;
  late int letters;
  late int revelationOrder;

  final verses = IsarLinks<Verse>();
}

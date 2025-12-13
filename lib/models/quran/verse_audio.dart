import 'package:isar/isar.dart';

part 'verse_audio.g.dart';

@collection
class VerseAudio {
  Id id = Isar.autoIncrement;

  late String reciterIdentifier;

  late int surahId;
  late int verseId;

  late String filePath;
}

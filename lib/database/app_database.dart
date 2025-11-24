import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/quran/surah.dart';
import '../models/quran/verse.dart';

import 'surah_database.dart';

class AppDatabase {
  static Isar? _isar;
  static Isar get isar => _isar!;

  /// Initialize Isar database
  static Future<void> initialize() async {
    if (_isar != null && _isar!.isOpen) return;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        SurahSchema,
        VerseSchema,
      ],
      directory: dir.path,
      inspector: false,
    );

    await SurahDatabase.seedIfNeeded();
  }

  /// Close DB safely
  static Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }
}

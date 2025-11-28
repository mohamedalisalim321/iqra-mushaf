import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/quran/surah.dart';
import '../models/quran/verse.dart';
import '../models/quran/verse_data.dart';
import 'surah_database.dart';
import 'verse_data_database.dart';

class AppDatabase {
  static Isar? _isar;

  /// Public accessor (safe)
  static Isar get db {
    if (_isar == null || !_isar!.isOpen) {
      throw Exception(
          "Database not initialized. Call AppDatabase.initialize() first.");
    }
    return _isar!;
  }

  /// Initialize Isar (idempotent + safe)
  static Future<void> initialize() async {
    // Already open → skip
    if (_isar != null && _isar!.isOpen) return;

    // Get app directory safely
    final dir = await getApplicationDocumentsDirectory();

    // Open only once
    _isar = await Isar.open(
      [
        SurahSchema,
        VerseSchema,
        VerseDataSchema,
      ],
      directory: dir.path,
      inspector: false,
      compactOnLaunch: const CompactCondition(
        minBytes: 32 * 1024,
        minRatio: 1.6,
      ),
    );

    // Seed if not seeded
    await SurahDatabase.seedIfNeeded();
    await VerseDataDatabase.seedIfNeeded();
  }

  /// Clear all collections
  static Future<void> clearAll() async {
    final instance = _isar;
    if (instance == null || !instance.isOpen) return;

    await instance.writeTxn(() async {
      await instance.clear();
    });
  }

  /// Close safely
  static Future<void> close() async {
    final instance = _isar;
    if (instance == null || !instance.isOpen) return;

    await instance.close();
    _isar = null;
  }
}

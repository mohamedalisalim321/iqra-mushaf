import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import '../models/quran/reciter.dart';
import '../services/audio_service.dart';
import 'app_database.dart';

class RecitersDatabase {
  static Isar get _isar => AppDatabase.db;

  /// Seed reciters only if the table is empty.
  static Future<void> seedIfNeeded() async {
    final count = await _isar.reciters.count();
    if (count > 0) return;

    print("Seeding reciters database...");

    try {
      final rawJson = await rootBundle.loadString("assets/data/reciters.json");
      final List<dynamic> list = jsonDecode(rawJson);

      final reciters = <Reciter>[];

      for (final rec in list) {
        if (rec is! Map<String, dynamic>) continue;

        reciters.add(
          Reciter()
            ..name = rec['name'] ?? ''
            ..engName = rec['englishName'] ?? ''
            ..identifier = rec['identifier'] ?? ''
            ..bitrate = rec['bitrate'] ?? 128,
        );
      }

      await _isar.writeTxn(() async {
        await _isar.reciters.putAll(reciters);
      });

      print("Reciters seeded: ${reciters.length}");

      /// Try to auto-select your preferred reciter.
      final defaultReciter =
          await _isar.reciters.filter().nameContains("محمد صديق").findFirst();

      if (defaultReciter != null) {
        AudioService.instance.setReciter(defaultReciter);
        print("Default reciter set: ${defaultReciter.name}");
      } else {
        /// Fallback: use first reciter
        final first = await _isar.reciters.where().findFirst();
        if (first != null) {
          AudioService.instance.setReciter(first);
          print("Fallback reciter set: ${first.name}");
        }
      }
    } catch (e, st) {
      print("❌ RecitersDatabase.seedIfNeeded error: $e");
      print(st);
    }
  }

  /// Get all reciters sorted alphabetically.
  static Future<List<Reciter>> getAllReciters() async {
    return _isar.reciters.where().sortByName().findAll();
  }

  /// Get reciter by identifier
  static Future<Reciter?> getByIdentifier(String id) async {
    return _isar.reciters.filter().identifierEqualTo(id).findFirst();
  }

  /// Set last used reciter (optional future feature)
  static Future<void> setLastUsed(Reciter reciter) async {
    AudioService.instance.setReciter(reciter);
  }
}

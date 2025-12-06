import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import '../models/quran/verse_data.dart';
import 'app_database.dart';

class VerseDataDatabase {
  static Isar get _isar => AppDatabase.db;

  /// Seed database if empty
  static Future<void> seedIfNeeded() async {
    final count = await _isar.verseDatas.count();
    if (count > 0) return;

    try {
      final rawJson =
          await rootBundle.loadString("assets/data/verses_data.json");

      // Parse JSON in background isolate
      final parsedList = await compute(_parseVerseDataJson, rawJson);

      // Batch insert
      await _isar.writeTxn(() async {
        await _isar.verseDatas.putAll(parsedList);
      });

      print(
          "VerseData seeding completed. Total entries: ${await _isar.verseDatas.count()}");
    } catch (e, st) {
      print("Error seeding VerseData: $e\n$st");
      throw Exception("Error seeding VerseData database: $e");
    }
  }

  /// Get a single word's VerseData by surah, verse, word
  static Future<VerseData?> getVerseData(
      int surahNumber, int verseNumber, int wordNumber) async {
    try {
      return await _isar.verseDatas
          .filter()
          .surahNumberEqualTo(surahNumber)
          .and()
          .verseNumberEqualTo(verseNumber)
          .and()
          .wordNumberEqualTo(wordNumber)
          .findFirst();
    } catch (e, st) {
      print("Error fetching VerseData: $e\n$st");
      rethrow;
    }
  }

  /// Fetch all words for a given verse
  static Future<List<VerseData>> getVerseWords(
      int surahNumber, int verseNumber) async {
    return await _isar.verseDatas
        .filter()
        .surahNumberEqualTo(surahNumber)
        .and()
        .verseNumberEqualTo(verseNumber)
        .sortByWordNumber()
        .findAll();
  }
}

/// ===========================================================
/// JSON parsing in background isolate
/// ===========================================================
List<VerseData> _parseVerseDataJson(String jsonStr) {
  final List<dynamic> data = jsonDecode(jsonStr);

  return data.map((v) {
    return VerseData()
      ..surahNumber = v["surah"] ?? 0
      ..verseNumber = v["ayah"] ?? 0
      ..wordNumber = v["word"] ?? 0
      ..sarf = v["sarf"] ?? ""
      ..irab = v["irab"] ?? ""
      ..wordMeaning = v["word_meaning"] ?? "";
  }).toList();
}

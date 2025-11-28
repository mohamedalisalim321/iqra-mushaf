import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:iqra/models/quran/verse_data.dart';
import 'package:isar/isar.dart';

import 'app_database.dart';

class VerseDataDatabase {
  static Isar get _isar => AppDatabase.db;

  static Future<void> seedIfNeeded() async {
    if (await _isar.verseDatas.count() > 0) return;

    try {
      final versesData = <VerseData>[];

      final raw = await rootBundle.loadString("assets/data/verses_data.json");
      final parsed = await compute(parseVersesData, raw);

      versesData.addAll(parsed);
      await _isar.writeTxn(() async {
        await _isar.verseDatas.putAll(versesData);
      });

      print(await _isar.verseDatas.count());
    } catch (e) {
      throw Exception("Error seeding database → $e");
    }
  }

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
    } catch (e) {
      rethrow;
    }
  }
}

List<VerseData> parseVersesData(String json) {
  List data = jsonDecode(json);

  return data.map((v) {
    return VerseData()
      ..surahNumber = v["surah"]
      ..verseNumber = v["ayah"]
      ..wordNumber = v["word"]
      ..sarf = v["sarf"]
      ..irab = v["irab"]
      ..wordMeaning = v["word_meaning"];
  }).toList();
}

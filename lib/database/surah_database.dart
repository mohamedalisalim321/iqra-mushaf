import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:iqra/providers/quran.dart';
import 'package:isar/isar.dart';

import '../models/quran/surah.dart';
import '../models/quran/verse.dart';
import 'app_database.dart';

class SurahDatabase {
  static Isar get _isar => AppDatabase.isar;

  static Future<void> seedIfNeeded() async {
    if (await _isar.surahs.count() > 0) return;

    final jsonString = await rootBundle.loadString("assets/data/quran.json");
    final List<dynamic> data = jsonDecode(jsonString);

    List<Surah> surahList = [];
    List<Verse> verseList = [];

    for (var s in data) {
      final surah = Surah()
        ..surahIndex = s["id"]
        ..surahName = s["name"]
        ..surahNameTr = s["name_tr"]
        ..surahType = s["type"]
        ..versesCount = s["verses_count"]
        ..revelationOrder = s["revelationOrder"]
        ..words = s["words"]
        ..letters = s["letters"];

      List<Verse> verses = (s["verses"] as List).map((v) {
        return Verse()
          ..surahName = s["name"]
          ..surahNumber = v["surah_number"]
          ..verseNumber = v["verse_number"]
          ..qcfData = v["qcfData"]
          ..qcfV4Data = v["qcfv4data"]
          ..verseText = v["content"]
          ..normalVerse = v["text_normal"];
      }).toList();

      // Add to global list
      verseList.addAll(verses);

      // Add links to surah
      surah.verses.addAll(verses);

      surahList.add(surah);
    }

    await _isar.writeTxn(() async {
      await _isar.verses.putAll(verseList);
      await _isar.surahs.putAll(surahList);

      // save links
      for (var s in surahList) {
        await s.verses.save();
      }
    });
  }

  static Future<List<Surah>> getAllSurahs() {
    return _isar.surahs.where().findAll();
  }

  static getVerse(int surahNumber, int verseNumber) async {
    final verse = await _isar.verses
        .where()
        .filter()
        .surahNumberEqualTo(surahNumber)
        .verseNumberEqualTo(verseNumber)
        .findFirst();
    return verse;
  }

  static Future<String> getVerseQcf(int surahNumber, int verseNumber,
      {bool verseEndSymbol = true}) async {
    final verse = await _isar.verses
        .where()
        .filter()
        .surahNumberEqualTo(surahNumber)
        .verseNumberEqualTo(verseNumber)
        .findFirst();

    String verseText = (verseEndSymbol)
        ? verse!.qcfData
        : verse!.qcfData.substring(0, verse.qcfData.length - 1);

    return verseText;
  }

  static getVerseNumberQcf(int verseNumber, {bool arabicNumeral = true}) async {
    var arabicNumeric = '';
    var digits = verseNumber.toString().split("").toList();

    if (!arabicNumeral) return '\u06dd${verseNumber.toString()}';

    const Map arabicNumbers = {
      "0": "٠",
      "1": "۱",
      "2": "۲",
      "3": "۳",
      "4": "٤",
      "5": "٥",
      "6": "٦",
      "7": "۷",
      "8": "۸",
      "9": "۹",
    };

    for (var e in digits) {
      arabicNumeric += arabicNumbers[e];
    }

    return '\u06dd$arabicNumeric';
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:iqra/utils/utils.dart';
import 'package:isar/isar.dart';

import '../models/quran/surah.dart';
import '../models/quran/verse.dart';
import '../providers/quran_pages.dart';
import 'app_database.dart';

class SurahDatabase {
  static Isar get _isar => AppDatabase.db;

  // caches
  static final _verseCache = <String, Verse>{};
  static final _pageCache = <int, List<dynamic>>{};
  static final _pageNumberCache = <String, int>{};
  static final _arabicNumCache = <int, String>{};

  static const int _maxCacheSize = 500;
  static const String _sep = ":";

  static Future<void> seedIfNeeded() async {
    if (await _isar.surahs.count() > 0) return;

    print('Seeding Quran database from assets/data/quran.json');

    try {
      final raw = await rootBundle.loadString("assets/data/quran.json");
      final List<dynamic> data = jsonDecode(raw);

      final surahs = <Surah>[];
      final verses = <Verse>[];

      for (final s in data) {
        if (s is! Map<String, dynamic>) continue;

        final surah = Surah()
          ..surahIndex = s['id'] as int? ?? 0
          ..surahName = s['name'] as String? ?? ''
          ..surahNameTr = s['name_tr'] as String? ?? ''
          ..surahType = s['type'] as String? ?? ''
          ..versesCount = s['verses_count'] as int? ?? 0
          ..revelationOrder = s['revelationOrder'] as int? ?? 0
          ..words = s['words'] as int? ?? 0
          ..letters = s['letters'] as int? ?? 0;

        final versesList = s['verses'] as List?;
        if (versesList == null) continue;

        final surahVerses = <Verse>[];
        for (final entry in versesList.asMap().entries) {
          // final i = entry.key;
          final v = entry.value;

          if (v is! Map<String, dynamic>) continue;

          final verse = Verse()
            ..surahName = surah.surahName
            ..surahNumber = v['surah_number'] as int? ?? 0
            ..verseNumber = v['verse_number'] as int? ?? 0
            // ..verseIndex = i + 1
            ..qcfData = v['qcfData'] as String? ?? ''
            ..qcfV4Data = v['qcfv4data'] as String? ?? ''
            ..verseText = v['content'] as String? ?? ''
            ..normalVerse = v['text_normal'] as String? ?? '';

          surahVerses.add(verse);
        }

        verses.addAll(surahVerses);
        surah.verses.addAll(surahVerses);
        surahs.add(surah);
      }

      await _isar.writeTxn(() async {
        await _isar.verses.putAll(verses);
        await _isar.surahs.putAll(surahs);
      });

      print(
          'Database seeded successfully: ${surahs.length} surahs, ${verses.length} verses');
    } catch (e) {
      print('❌ Failed to seed Quran database');
      throw Exception('Error seeding database → $e');
    }
  }

  static Future<Surah?> getSurah(int surahNumber) async {
    if (surahNumber < 1 || surahNumber > 114) return null;
    try {
      return await _isar.surahs
          .filter()
          .surahIndexEqualTo(surahNumber)
          .findFirst();
    } catch (e) {
      throw Exception('Error fetching surah $surahNumber → $e');
    }
  }

  static Future<List<Surah>> getAllSurahs() async {
    try {
      return await _isar.surahs.where().findAll();
    } catch (e) {
      throw Exception('Error fetching all surahs → $e');
    }
  }

  static Future<Verse?> getVerse(int surahNumber, int verseNumber) async {
    if (surahNumber < 1 || surahNumber > 114 || verseNumber < 1) return null;

    final key = '$surahNumber$_sep$verseNumber';
    if (_verseCache.containsKey(key)) return _verseCache[key];

    try {
      final verse = await _isar.verses
          .filter()
          .surahNumberEqualTo(surahNumber)
          .and()
          .verseNumberEqualTo(verseNumber)
          .findFirst();

      if (verse != null) _put(_verseCache, key, verse);
      return verse;
    } catch (e) {
      throw Exception('Error fetching verse $surahNumber:$verseNumber → $e');
    }
  }

  static Future<Verse?> getRandomVerse() async {
    try {
      final surah = await getSurah(Random().nextInt(114));

      final verse = await getVerse(surah!.surahIndex, surah.versesCount);

      return verse;
    } catch (e) {
      throw Exception('Error fetching verse $e');
    }
  }

  static Future<Verse> getVerseQcf(int surah, int verse,
      {bool verseEndSymbol = true}) async {
    final data = await getVerse(surah, verse);
    if (data == null) throw Exception('Verse not found → $surah:$verse');
    return data;
  }

  static Future<String> getVerseNumberQcf(int verseNumber,
      {bool arabicNumeral = true}) async {
    final verse =
        await _isar.verses.filter().verseNumberEqualTo(verseNumber).findFirst();

    if (verse == null || verse.qcfData.isEmpty) {
      return arabicNumeral ? verseNumber.toArabicDigits() : '$verseNumber';
    }

    final qcfDigit = verse.qcfData.substring(verse.qcfData.length - 1);
    return qcfDigit;
  }

  static List<dynamic> getPageData(int page) {
    if (page < 1 || page > 604) {
      throw Exception('Invalid page number → $page (must be 1–604)');
    }

    return _pageCache.putIfAbsent(
        page, () => List.unmodifiable(quranPages[page - 1]));
  }

  static int getPageNumber(int surah, int verse) {
    if (surah < 1 || surah > 114 || verse < 1) {
      throw Exception('Invalid verse reference → $surah:$verse');
    }

    final key = '$surah$_sep$verse';
    return _pageNumberCache.putIfAbsent(
        key, () => _binarySearchPage(surah, verse));
  }

  static int _binarySearchPage(int surah, int verse) {
    int low = 0;
    int high = quranPages.length - 1;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final ranges = quranPages[mid];

      for (final r in ranges) {
        final s = r['surah'] as int;
        final start = r['start'] as int;
        final end = r['end'] as int;
        if (s == surah && verse >= start && verse <= end) {
          return mid + 1;
        }
      }

      final first = ranges.first;
      final last = ranges.last;
      final firstSurah = first['surah'] as int;
      final firstStart = first['start'] as int;
      final lastSurah = last['surah'] as int;
      final lastEnd = last['end'] as int;

      if (surah < firstSurah || (surah == firstSurah && verse < firstStart)) {
        high = mid - 1;
      } else if (surah > lastSurah || (surah == lastSurah && verse > lastEnd)) {
        low = mid + 1;
      } else {
        break;
      }
    }

    for (int i = 0; i < quranPages.length; i++) {
      for (final r in quranPages[i]) {
        if (r['surah'] == surah && verse >= r['start']! && verse <= r['end']!) {
          return i + 1;
        }
      }
    }

    throw Exception('Verse page not found → $surah:$verse');
  }

  static Future<List<Verse>> searchVerses(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    return await _isar.verses
        .filter()
        .normalVerseContains(trimmed.toLowerCase(), caseSensitive: false)
        .findAll();
  }

  static void _put<K, V>(Map<K, V> map, K key, V value) {
    if (map.length >= _maxCacheSize && !map.containsKey(key)) {
      map.remove(map.keys.first);
    }
    map[key] = value;
  }

  static void clearCache() {
    _verseCache.clear();
    _pageCache.clear();
    _pageNumberCache.clear();
    _arabicNumCache.clear();
  }

  static Map<String, int> getCacheStats() => {
        'verses': _verseCache.length,
        'pages': _pageCache.length,
        'pageNumbers': _pageNumberCache.length,
        'arabicNumbers': _arabicNumCache.length,
      };

  static void dispose() => clearCache();
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import '../models/quran/surah.dart';
import '../models/quran/verse.dart';
import '../providers/quran_pages.dart';
import 'app_database.dart';

class SurahDatabase {
  static Isar get _isar => AppDatabase.db;

  // ------------------ CACHES ------------------ //

  static final _verseCache = <String, Verse>{};
  static final _pageCache = <int, List>{};
  static final _pageNumberCache = <String, int>{};
  static final _arabicNumCache = <int, String>{};

  static const int _maxCacheSize = 500;
  static const String _sep = ":";

  // ------------------ SEEDING ------------------ //

  static Future<void> seedIfNeeded() async {
    if (await _isar.surahs.count() > 0) return;

    try {
      final raw = await rootBundle.loadString("assets/data/quran.json");
      final List data = jsonDecode(raw);

      final surahs = <Surah>[];
      final verses = <Verse>[];

      for (final s in data) {
        final surah = Surah()
          ..surahIndex = s["id"] ?? 0
          ..surahName = s["name"] ?? ""
          ..surahNameTr = s["name_tr"] ?? ""
          ..surahType = s["type"] ?? ""
          ..versesCount = s["verses_count"] ?? 0
          ..revelationOrder = s["revelationOrder"] ?? 0
          ..words = s["words"] ?? 0
          ..letters = s["letters"] ?? 0;

        final surahVerses = (s["verses"] as List).map((v) {
          return Verse()
            ..surahName = surah.surahName
            ..surahNumber = v["surah_number"] ?? 0
            ..verseNumber = v["verse_number"] ?? 0
            ..qcfData = v["qcfData"] ?? ""
            ..qcfV4Data = v["qcfv4data"] ?? ""
            ..verseText = v["content"] ?? ""
            ..normalVerse = v["text_normal"] ?? "";
        }).toList();

        verses.addAll(surahVerses);
        surah.verses.addAll(surahVerses);

        surahs.add(surah);
      }

      await _isar.writeTxn(() async {
        await _isar.verses.putAll(verses);
        await _isar.surahs.putAll(surahs);

        for (final s in surahs) {
          await s.verses.save();
        }
      });
    } catch (e) {
      throw Exception("Error seeding database → $e");
    }
  }
  // ------------------ SURAH QUERIES ------------------ //

  static Future<Surah?> getSurah(int surahNumber) async {
    try {
      return await _isar.surahs
          .filter()
          .surahIndexEqualTo(surahNumber)
          .findFirst();
    } catch (e) {
      throw Exception("Error fetching surah → $e");
    }
  }

  static Future<List<Surah>> getAllSurahs() async {
    try {
      return await _isar.surahs.where().findAll();
    } catch (e) {
      throw Exception("Error fetching all surahs → $e");
    }
  }

  // ------------------ VERSE QUERIES ------------------ //

  static Future<Verse?> getVerse(int surahNumber, int verseNumber) async {
    final key = "$surahNumber$_sep$verseNumber";

    if (_verseCache.containsKey(key)) return _verseCache[key];

    try {
      // Fast index-based lookup
      final verse = await _isar.verses
          .filter()
          .surahNumberEqualTo(surahNumber)
          .and()
          .verseNumberEqualTo(verseNumber)
          .findFirst();

      if (verse != null) _put(_verseCache, key, verse);

      return verse;
    } catch (e) {
      throw Exception("Error fetching verse → $e");
    }
  }

  static Future<Verse> getVerseQcf(
    int surah,
    int verse, {
    bool verseEndSymbol = true,
  }) async {
    final data = await getVerse(surah, verse);

    if (data == null) {
      throw Exception("Verse not found → $surah:$verse");
    }

    // if (!verseEndSymbol && text.isNotEmpty) {
    //   text = text.substring(0, text.length - 1);
    // }

    return data;
  }

  // ------------------ VERSE NUMBER → QCF ------------------ //

  static getVerseNumberQcf(int verseNumber, {bool arabicNumeral = true}) async {
    final verse =
        await _isar.verses.filter().verseNumberEqualTo(verseNumber).findFirst();

    return verse!.qcfData.substring(verse.qcfData.length - 1);
  }

  // ------------------ PAGE QUERIES ------------------ //

  static List getPageData(int page) {
    if (page < 1 || page > 604) {
      throw Exception("Invalid page number → $page (must be 1–604)");
    }

    if (_pageCache.containsKey(page)) return _pageCache[page]!;

    final data = quranPages[page - 1];
    _put(_pageCache, page, data);

    return data;
  }

  static int getPageNumber(int surah, int verse) {
    final key = "$surah$_sep$verse";

    if (_pageNumberCache.containsKey(key)) {
      return _pageNumberCache[key]!;
    }

    final page = _binarySearchPage(surah, verse);

    _put(_pageNumberCache, key, page);
    return page;
  }

  /// Faster than linear search (log₂ 604 = ~9 checks)
  static int _binarySearchPage(int surah, int verse) {
    int low = 0;
    int high = quranPages.length - 1;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final ranges = quranPages[mid];

      // Check if the verse is in any surah range on this page
      for (final r in ranges) {
        final s = r['surah'] as int;
        final start = r['start'] as int;
        final end = r['end'] as int;

        if (s == surah && verse >= start && verse <= end) {
          return mid + 1; // pages are 1-based
        }
      }

      // Decide direction: compare *first* surah on page vs target
      final firstSurah = ranges.first['surah'] as int;
      final lastSurah = ranges.last['surah'] as int;

      if (surah < firstSurah || (surah == firstSurah && verse < ranges.first['start'])) {
        high = mid - 1;
      } else if (surah > lastSurah || (surah == lastSurah && verse > ranges.last['end'])) {
        low = mid + 1;
      } else {
        // Might span pages — fallback to linear (rare)
        break;
      }
    }

    // Fallback: linear scan (should rarely happen)
    for (int i = 0; i < quranPages.length; i++) {
      for (final r in quranPages[i]) {
        if (r['surah'] == surah &&
            verse >= r['start'] &&
            verse <= r['end']) {
          return i + 1;
        }
      }
    }

    throw Exception("Verse page not found → $surah:$verse");
  }


  // ------------------ SEARCH ------------------ //

  static Future<List<Verse>> searchVerses(
    String query, {
    int limit = 60,
  }) async {
    final q = query.toLowerCase();

    return _isar.verses
        .filter()
        .normalVerseContains(q, caseSensitive: false)
        .limit(limit)
        .findAll();
  }

  // ------------------ CACHE UTILS ------------------ //

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
        "verses": _verseCache.length,
        "pages": _pageCache.length,
        "pageNumbers": _pageNumberCache.length,
        "arabicNumbers": _arabicNumCache.length,
      };

  static void dispose() => clearCache();
}

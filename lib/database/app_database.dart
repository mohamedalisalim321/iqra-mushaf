import 'dart:async';
import 'dart:io';

import 'package:iqra/models/quran/verse_audio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/quran/reciter.dart';
import '../models/quran/surah.dart';
import '../models/quran/verse.dart';
import '../models/quran/verse_data.dart';
import 'reciters_database.dart';
import 'surah_database.dart';
import 'verse_data_database.dart';

class AppDatabase {
  static Isar? _isar;
  static bool _initializing = false;
  static bool _closed = false;

  /// Getter with safety checks
  static Isar get db {
    if (_isar == null || !_isar!.isOpen) {
      if (_closed) {
        throw StateError(
            "AppDatabase has been closed. Re-initialization is not supported.");
      }
      throw StateError(
          "AppDatabase not initialized. Call AppDatabase.initialize() first.");
    }
    return _isar!;
  }

  // ------------------------------------------------------------
  // INITIALIZE
  // ------------------------------------------------------------

  static Future<void> initialize() async {
    if (_isar?.isOpen == true) return;

    // If already initializing → wait
    if (_initializing) {
      await _waitUntilInitialized();
      return;
    }

    if (_closed) {
      throw StateError("Cannot re-initialize after database has been closed.");
    }

    _initializing = true;
    print("Initializing Isar database...");

    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = dir.path;

      _isar = await _openOrRecover(path);

      /// Seed databases one by one IN ORDER
      /// So RecitersDatabase finishes → AudioService can use reciter
      await SurahDatabase.seedIfNeeded();
      await VerseDataDatabase.seedIfNeeded();
      await RecitersDatabase.seedIfNeeded();

      print("Isar database initialized successfully.");
    } catch (e, st) {
      print("❌ DATABASE INIT ERROR:");
      print(e);
      print(st);
      await _isar?.close();
      _isar = null;
      rethrow;
    } finally {
      _initializing = false;
    }
  }

  // ------------------------------------------------------------
  // WAIT HELPER
  // ------------------------------------------------------------

  static Future<void> _waitUntilInitialized() async {
    final completer = Completer<void>();

    Future.doWhile(() async {
      if (_initializing) {
        await Future.delayed(const Duration(milliseconds: 15));
        return true;
      }
      return false;
    }).then((_) {
      completer.complete();
    });

    return completer.future;
  }

  // ------------------------------------------------------------
  // OPEN OR RECOVER
  // ------------------------------------------------------------

  static Future<Isar> _openOrRecover(String path) async {
    try {
      return await _openIsar(path);
    } catch (e) {
      print("⚠️ Isar open failed → attempting recovery...");
      print(e);
    }

    // Delete corrupted DB directory
    try {
      final directory = Directory(path);
      if (directory.existsSync()) {
        await directory.delete(recursive: true);
        print("Old database deleted. Rebuilding...");
      }
    } catch (cleanupError) {
      print("Cleanup error: $cleanupError");
    }

    // Try again
    return await _openIsar(path);
  }

  // ------------------------------------------------------------
  // LOW-LEVEL OPEN
  // ------------------------------------------------------------

  static Future<Isar> _openIsar(String path) async {
    try {
      return await Isar.open(
        [
          SurahSchema,
          VerseSchema,
          VerseAudioSchema,
          VerseDataSchema,
          ReciterSchema,
        ],
        directory: path,
        inspector: false,
        // Auto compaction to save space
        compactOnLaunch: const CompactCondition(
          minBytes: 100 * 1024,
          minRatio: 2.0,
        ),
      );
    } catch (e) {
      print("❌ Failed to open Isar: $e");
      rethrow;
    }
  }

  // ------------------------------------------------------------
  // CLEAR ALL
  // ------------------------------------------------------------

  static Future<void> clearAll() async {
    if (_isar == null || !_isar!.isOpen) return;

    try {
      await _isar!.writeTxn(() async {
        await _isar!.clear();
      });
      print("Database cleared successfully.");
    } catch (e) {
      print("Error clearing database: $e");
    }
  }

  // ------------------------------------------------------------
  // CLOSE
  // ------------------------------------------------------------

  static Future<void> close() async {
    if (_isar == null || !_isar!.isOpen) return;

    try {
      await _isar!.close();
      _isar = null;
      _closed = true;
      _initializing = false;

      SurahDatabase.dispose();

      print("Database closed successfully.");
    } catch (e) {
      print("Error closing database: $e");
    }
  }
}

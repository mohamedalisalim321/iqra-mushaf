import 'dart:async';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/quran/surah.dart';
import '../models/quran/verse.dart';
import '../models/quran/verse_data.dart';
import 'surah_database.dart';
import 'verse_data_database.dart';

class AppDatabase {
  static Isar? _isar;
  static bool _initializing = false;
  static bool _closed = false;

  // Database accessor with error handling
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

  // Accessor for collections
  static IsarCollection<Surah> get surahs => db.surahs;
  static IsarCollection<Verse> get verses => db.verses;
  static IsarCollection<VerseData> get verseData => db.verseDatas;

  // Initializes the database
  static Future<void> initialize() async {
    if (_isar?.isOpen == true) return;

    if (_initializing) {
      await _waitForInitialization();
      return;
    }

    if (_closed) {
      throw StateError("Cannot re-initialize after database has been closed.");
    }

    _initializing = true;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = dir.path;

      _isar = await _openOrRecover(dbPath);

      // Seed the database if needed
      await Future.wait([
        SurahDatabase.seedIfNeeded(),
        VerseDataDatabase.seedIfNeeded(),
      ]);
    } catch (e) {
      _isar?.close();
      _isar = null;
      rethrow;
    } finally {
      _initializing = false;
    }
  }

  // Waits until the database is initialized
  static Future<void> _waitForInitialization() async {
    final completer = Completer<void>();
    Timer? timer;
    void check() {
      if (!_initializing) {
        timer?.cancel();
        completer.complete();
      } else {
        timer = Timer(const Duration(milliseconds: 20), check);
      }
    }

    check();
    return completer.future;
  }

  // Tries to open the Isar database or recovers it if an error occurs
  static Future<Isar> _openOrRecover(String path) async {
    try {
      return await _openIsar(path);
    } on IsarError catch (e) {
      print("Isar error: $e");
    } catch (e) {
      print("Unexpected error: $e");
      rethrow;
    }

    // If the database opening fails, attempt recovery
    try {
      final dbDir = Directory(path);
      if (dbDir.existsSync()) {
        await dbDir.delete(recursive: true); // Cleanup the existing DB
      }
    } catch (cleanupError) {
      print("Error during cleanup: $cleanupError");
    }

    return await _openIsar(path);
  }

  // Opens the Isar database with the provided path
  static Future<Isar> _openIsar(String path) async {
    try {
      return await Isar.open(
        [
          SurahSchema,
          VerseSchema,
          VerseDataSchema,
        ],
        directory: path,
        inspector: false,
        compactOnLaunch: const CompactCondition(
          minBytes: 128 * 1024, // Set conditions to compact the DB
          minRatio: 2.0,
        ),
      );
    } catch (e) {
      print("Failed to open Isar database: $e");
      rethrow;
    }
  }

  // Clears all data from the database
  static Future<void> clearAll() async {
    final instance = _isar;
    if (instance == null || !instance.isOpen) return;

    try {
      await instance.writeTxn(() async {
        await instance.clear();
      });
      print("Database cleared successfully.");
    } catch (e) {
      print("Error clearing the database: $e");
    }
  }

  // Closes the database
  static Future<void> close() async {
    final instance = _isar;
    if (instance == null || !instance.isOpen) return;

    try {
      await instance.close();
      _isar = null;
      _closed = true;
      _initializing = false;

      // Dispose of additional resources if needed
      SurahDatabase.dispose();
      print("Database closed successfully.");
    } catch (e) {
      print("Error closing the database: $e");
    }
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/quran/surah.dart';
import '../models/quran/verse.dart';
import '../models/quran/verse_data.dart';
import 'surah_database.dart';
import 'verse_data_database.dart';

/// Centralized, singleton-style Isar database manager for the app.
/// Handles initialization, recovery, seeding, and safe access.
class AppDatabase {
  static Isar? _isar;
  static bool _initializing = false;
  static bool _closed = false;

  /// Throws if database is not initialized or was closed.
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

  // Convenience getters
  static IsarCollection<Surah> get surahs => db.surahs;
  static IsarCollection<Verse> get verses => db.verses;
  static IsarCollection<VerseData> get verseData => db.verseDatas;

  /// ==========================================================================
  /// INITIALIZATION (Thread-safe & Idempotent)
  /// ==========================================================================

  /// Initializes the Isar database once. Safe to call multiple times.
  /// Throws if initialization fails.
  static Future<void> initialize() async {
    // Fast path: already open
    if (_isar?.isOpen == true) return;

    // Prevent concurrent initialization
    if (_initializing) {
      // Wait for ongoing init (avoid recursion or race)
      await _waitForInitialization();
      return;
    }

    if (_closed) {
      throw StateError("Cannot re-initialize after database has been closed.");
    }

    _initializing = true;
    Completer<void>? completer;

    try {
      // Get documents dir
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = dir.path;

      // Open (with recovery on corruption)
      _isar = await _openOrRecover(dbPath);

      // Seed data — ensure this runs AFTER open
      await Future.wait([
        SurahDatabase.seedIfNeeded(),
        VerseDataDatabase.seedIfNeeded(),
      ]);
    } catch (e, stack) {
      _isar?.close();
      _isar = null;
      debugPrint("❌ AppDatabase initialization failed: $e\n$stack");
      rethrow;
    } finally {
      _initializing = false;
      // Complete any waiting futures
      if (completer != null && !completer.isCompleted) {
        completer.complete();
      }
    }
  }

  /// Helper to wait for initialization without recursion
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

  /// ==========================================================================
  /// DATABASE OPEN & RECOVERY
  /// ==========================================================================

  /// Opens Isar with automatic corruption recovery.
  static Future<Isar> _openOrRecover(String path) async {
    try {
      return await _openIsar(path);
    } on IsarError catch (e) {
      log("Isar open failed – attempting recovery", error: e.toString());
    } catch (e) {
      log("Unexpected error during Isar open", error: e.toString());
      rethrow; // Don't recover from non-Isar errors
    }

    // Recovery: delete and retry
    try {
      final dbDir = Directory(path);
      if (dbDir.existsSync()) {
        log("Deleting corrupted Isar database directory: $path");
        await dbDir.delete(recursive: true);
      }
    } catch (cleanupError) {
      log("Failed to clean up corrupted database",
          error: cleanupError.toString());
      // Continue anyway – Isar will create new dir
    }

    // Retry open
    return await _openIsar(path);
  }

  /// Actual Isar open call with config
  static Future<Isar> _openIsar(String path) async {
    return await Isar.open(
      [
        SurahSchema,
        VerseSchema,
        VerseDataSchema,
      ],
      directory: path,
      // Enable inspector only in debug mode
      inspector: false,
      // Compact only if fragmentation is significant
      compactOnLaunch: const CompactCondition(
        minBytes: 128 * 1024, // 128 KB – reduce I/O on small devices
        minRatio: 2.0, // Compact if size is 2x logical data
      ),
      // Optional: add version for future migrations
      // version: 1,
    );
  }

  /// ==========================================================================
  /// MAINTENANCE
  /// ==========================================================================

  /// Clears all collections in a single transaction.
  static Future<void> clearAll() async {
    final instance = _isar;
    if (instance == null || !instance.isOpen) return;

    await instance.writeTxn(() async {
      await instance.clear();
    });
  }

  /// Closes the database and disallows further access.
  /// Cannot be re-initialized after close.
  static Future<void> close() async {
    final instance = _isar;
    if (instance == null || !instance.isOpen) return;

    await instance.close();
    _isar = null;
    _closed = true;
    _initializing = false;

    // Allow downstream caches to clean up
    SurahDatabase.dispose();
    // Add other disposables if needed
  }
}

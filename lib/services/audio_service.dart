import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../database/app_database.dart';
import '../database/reciters_database.dart';
import '../database/surah_database.dart';
import '../models/quran/reciter.dart';
import '../models/quran/verse.dart';
import '../models/quran/verse_audio.dart';

class AudioService {
  AudioService._internal();
  static final AudioService instance = AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  static Isar get isar => AppDatabase.db;

  /// ────────────────────────────
  /// STATE
  /// ────────────────────────────
  final ValueNotifier<Verse?> currentVerse = ValueNotifier(null);
  final ValueNotifier<Reciter?> currentReciter = ValueNotifier(null);
  final ValueNotifier<bool> playing = ValueNotifier(false);

  final ValueNotifier<bool> repeatVerse = ValueNotifier(false);
  final ValueNotifier<double> playbackSpeed = ValueNotifier(1.0);

  bool autoPlayNext = true;

  /// ────────────────────────────
  /// STREAMS
  /// ────────────────────────────
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  ValueNotifier<Reciter?> get reciter => currentReciter;

  /// ────────────────────────────
  /// INIT
  /// ────────────────────────────
  static Future<void> init() async {
    final service = AudioService.instance;

    /// play / pause state
    service._player.playerStateStream.listen((state) {
      service.playing.value = state.playing;
    });

    /// auto next / repeat
    service._player.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        if (service.repeatVerse.value) {
          await service._player.seek(Duration.zero);
          await service._player.play();
        } else {
          await service._handleAutoNext();
        }
      }
    });

    /// seed reciters
    await RecitersDatabase.seedIfNeeded();
    final reciters = await RecitersDatabase.getAllReciters();
    if (reciters.isNotEmpty) {
      service.setReciter(reciters.first);
    }
  }

  /// ────────────────────────────
  /// RECITER
  /// ────────────────────────────
  void setReciter(Reciter reciter) {
    currentReciter.value = reciter;
  }

  String getVerseUrl(Verse verse) {
    final r = currentReciter.value!;
    return "https://cdn.islamic.network/quran/audio/${r.bitrate}/${r.identifier}/${verse.id}.mp3";
  }

  /// ────────────────────────────
  /// CACHE
  /// ────────────────────────────
  Future<VerseAudio?> getCachedAudio(Verse verse) async {
    return await isar.verseAudios
        .filter()
        .reciterIdentifierEqualTo(currentReciter.value!.identifier)
        .surahIdEqualTo(verse.surahNumber)
        .verseIdEqualTo(verse.id) // ✅ FIXED
        .findFirst();
  }

  Future<VerseAudio> downloadVerse(Verse verse) async {
    final dir = await getApplicationDocumentsDirectory();
    final reciterFolder =
        "${dir.path}/audio/${currentReciter.value!.identifier}";

    await Directory(reciterFolder).create(recursive: true);

    final filePath = "$reciterFolder/${verse.id}.mp3";
    final file = File(filePath);

    if (!await file.exists()) {
      final response = await http.get(Uri.parse(getVerseUrl(verse)));
      if (response.statusCode != 200) {
        throw Exception("Failed to download verse audio");
      }
      await file.writeAsBytes(response.bodyBytes);
    }

    final audio = VerseAudio()
      ..reciterIdentifier = currentReciter.value!.identifier
      ..surahId = verse.surahNumber
      ..verseId = verse.verseNumber
      ..filePath = filePath;

    await isar.writeTxn(() async {
      await isar.verseAudios.put(audio);
    });

    return audio;
  }

  /// ────────────────────────────
  /// PLAYBACK
  /// ────────────────────────────
  Future<void> playVerse(Verse verse) async {
    currentVerse.value = verse;

    try {
      VerseAudio? audio = await getCachedAudio(verse);
      audio ??= await downloadVerse(verse);

      await _player.setFilePath(audio.filePath);
      await _player.setSpeed(playbackSpeed.value);
      await _player.play();

      _prefetchNext();
    } catch (e) {
      debugPrint("❌ Play error: $e");
    }
  }

  Future<void> playNextVerse() async {
    if (currentVerse.value == null) return;

    final surah = await SurahDatabase.getSurah(currentVerse.value!.surahNumber);
    final next = currentVerse.value!.verseNumber + 1;

    if (next > surah!.versesCount) return;

    final v = await SurahDatabase.getVerseQcf(
      currentVerse.value!.surahNumber,
      next,
    );

    await playVerse(v);
  }

  Future<void> playPreviousVerse() async {
    if (currentVerse.value == null) return;

    final prev = currentVerse.value!.verseNumber - 1;
    if (prev < 1) return;

    final v = await SurahDatabase.getVerseQcf(
      currentVerse.value!.surahNumber,
      prev,
    );

    await playVerse(v);
  }

  Future<void> _handleAutoNext() async {
    if (!autoPlayNext || currentVerse.value == null) return;
    await playNextVerse();
  }

  Future<void> _prefetchNext() async {
    if (currentVerse.value == null) return;

    final surah = await SurahDatabase.getSurah(currentVerse.value!.surahNumber);
    final next = currentVerse.value!.verseNumber + 1;

    if (next > surah!.versesCount) return;

    final v = await SurahDatabase.getVerseQcf(
      currentVerse.value!.surahNumber,
      next,
    );

    if (await getCachedAudio(v) == null) {
      downloadVerse(v); // fire & forget
    }
  }

  /// ────────────────────────────
  /// CONTROLS
  /// ────────────────────────────
  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration d) => _player.seek(d);

  void toggleRepeatVerse() {
    repeatVerse.value = !repeatVerse.value;
  }

  void setPlaybackSpeed(double speed) {
    playbackSpeed.value = speed;
    _player.setSpeed(speed);
  }

  /// ────────────────────────────
  /// DISPOSE
  /// ────────────────────────────
  Future<void> dispose() async {
    await _player.dispose();
  }
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';
// import 'package:just_audio/just_audio.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

// import '../database/app_database.dart';
// import '../database/reciters_database.dart';
// import '../database/surah_database.dart';
// import '../models/quran/reciter.dart';
// import '../models/quran/verse.dart';
// import '../models/quran/verse_audio.dart';

// class AudioService {
//   AudioService._internal();
//   static final AudioService instance = AudioService._internal();

//   final AudioPlayer _player = AudioPlayer();
//   static Isar get isar => AppDatabase.db;

//   /// State Notifiers
//   static final currentVerse = ValueNotifier<Verse?>(null);
//   static final currentReciter = ValueNotifier<Reciter?>(null);
//   static final isPlaying = ValueNotifier<bool>(false);
//   static final playbackSpeed = ValueNotifier<double>(1.0);

//   /// Auto-play next verse
//   bool autoPlayNext = true;

//   /// Streams exposed to UI
//   Stream<PlayerState> get playerStateStream => _player.playerStateStream;
//   Stream<Duration> get positionStream => _player.positionStream;
//   Stream<Duration?> get durationStream => _player.durationStream;

//   ValueNotifier<Reciter?> get reciter => currentReciter;
//   ValueNotifier<bool> get playing => isPlaying;

//   /// ---------------------------------------------------------
//   /// INITIALIZATION
//   /// ---------------------------------------------------------
//   static Future<void> init() async {
//     final service = AudioService.instance;

//     /// Update play/pause on UI
//     service._player.playerStateStream.listen((state) {
//       isPlaying.value = state.playing;
//     });

//     /// Auto-next-verse logic
//     service._player.processingStateStream.listen((state) async {
//       if (state == ProcessingState.completed) {
//         await service._handleNextVerseAuto();
//       }
//     });

//     /// Ensure reciters exist
//     await RecitersDatabase.seedIfNeeded();
//     final reciters = await RecitersDatabase.getAllReciters();
//     if (reciters.isNotEmpty) {
//       service.setReciter(reciters.first);
//     }
//   }

//   void setReciter(Reciter reciter) {
//     currentReciter.value = reciter;
//   }

//   String getVerseUrl(Verse verse) {
//     final r = currentReciter.value!;
//     return "https://cdn.islamic.network/quran/audio/${r.bitrate}/${r.identifier}/${verse.id}.mp3";
//   }

//   Future<VerseAudio?> getCachedAudio(Verse verse) async {
//     return await isar.verseAudios
//         .filter()
//         .reciterIdentifierEqualTo(currentReciter.value!.identifier)
//         .surahIdEqualTo(verse.surahNumber)
//         .verseIdEqualTo(verse.id)
//         .findFirst();
//   }

//   Future<VerseAudio> downloadVerse(Verse verse) async {
//     final dir = await getApplicationDocumentsDirectory();
//     final reciterFolder =
//         "${dir.path}/audio/${currentReciter.value!.identifier}";

//     await Directory(reciterFolder).create(recursive: true);

//     final filePath = "$reciterFolder/${verse.id}.mp3";
//     final file = File(filePath);

//     if (!await file.exists()) {
//       try {
//         final url = getVerseUrl(verse);
//         final response = await http.get(Uri.parse(url));

//         if (response.statusCode != 200) {
//           throw Exception("Failed to download audio");
//         }

//         await file.writeAsBytes(response.bodyBytes);
//       } catch (e) {
//         print("❌ Download error for ayah ${verse.verseNumber}: $e");
//         rethrow;
//       }
//     }

//     final audio = VerseAudio()
//       ..reciterIdentifier = currentReciter.value!.identifier
//       ..surahId = verse.surahNumber
//       ..verseId = verse.verseNumber
//       ..filePath = filePath;

//     await isar.writeTxn(() async {
//       await isar.verseAudios.put(audio);
//     });

//     return audio;
//   }

//   Future<void> playVerse(Verse verse) async {
//     currentVerse.value = verse;

//     VerseAudio? cached = await getCachedAudio(verse);

//     try {
//       cached ??= await downloadVerse(verse);

//       await _player.setFilePath(cached.filePath);
//       await _player.play();

//       _prefetchNext();
//     } catch (e) {
//       print("❌ Play error: $e");
//     }
//   }

//   Future<void> _prefetchNext() async {
//     final surah = await SurahDatabase.getSurah(currentVerse.value!.surahNumber);

//     final nextIndex = currentVerse.value!.verseNumber + 1;
//     if (nextIndex >= surah!.versesCount) return;

//     final nextVerse = await SurahDatabase.getVerseQcf(
//         currentVerse.value!.surahNumber, currentVerse.value!.verseNumber + 1);

//     if (await getCachedAudio(nextVerse) == null) {
//       downloadVerse(nextVerse);
//     }
//   }

//   Future<void> _handleNextVerseAuto() async {
//     if (!autoPlayNext) return;

//     final surah = await SurahDatabase.getSurah(currentVerse.value!.surahNumber);

//     final nextIndex = currentVerse.value!.verseNumber + 1;
//     if (nextIndex >= surah!.versesCount) return;

//     final nextVerse = await SurahDatabase.getVerseQcf(
//         currentVerse.value!.surahNumber, currentVerse.value!.verseNumber + 1);

//     await playVerse(nextVerse);
//   }

//   /// ---------------------------------------------------------
//   /// CONTROLS
//   /// ---------------------------------------------------------
//   Future<void> pause() => _player.pause();
//   Future<void> resume() => _player.play();
//   Future<void> stop() => _player.stop();
//   Future<void> seek(Duration pos) => _player.seek(pos);

//   /// ---------------------------------------------------------
//   /// Dispose
//   /// ---------------------------------------------------------
//   Future<void> dispose() async => _player.dispose();
// }

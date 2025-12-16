import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../database/app_database.dart';
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

  /// 👇 UI visibility (derived, not toggled)
  final ValueNotifier<bool> showAudioPlayer = ValueNotifier(false);

  bool autoPlayNext = true;

  /// ────────────────────────────
  /// STREAMS
  /// ────────────────────────────
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  /// ────────────────────────────
  /// INIT
  /// ────────────────────────────
  static Future<void> init() async {
    final service = AudioService.instance;

    /// Play / pause
    service._player.playerStateStream.listen((state) {
      service.playing.value = state.playing;
      service._updateAudioPlayerVisibility();
    });

    /// Completion / repeat / auto-next
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
  Future<VerseAudio?> getCachedAudio(Verse verse) {
    return isar.verseAudios
        .filter()
        .reciterIdentifierEqualTo(currentReciter.value!.identifier)
        .surahIdEqualTo(verse.surahNumber)
        .verseIdEqualTo(verse.verseNumber)
        .findFirst();
  }

  Future<VerseAudio> downloadVerse(Verse verse) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = "${dir.path}/audio/${currentReciter.value!.identifier}";

    await Directory(folder).create(recursive: true);

    final filePath = "$folder/${verse.id}.mp3";
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
    _updateAudioPlayerVisibility();

    try {
      final audio = await getCachedAudio(verse) ?? await downloadVerse(verse);

      await _player.setFilePath(audio.filePath);
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
    if (!autoPlayNext || currentVerse.value == null) {
      stop();
      return;
    }
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

  Future<void> stop() async {
    await _player.stop();
    currentVerse.value = null;
    _updateAudioPlayerVisibility();
  }

  Future<void> seek(Duration d) => _player.seek(d);

  void toggleRepeatVerse() {
    repeatVerse.value = !repeatVerse.value;
  }

  /// ────────────────────────────
  /// UI VISIBILITY LOGIC (IMPORTANT)
  /// ────────────────────────────
  void _updateAudioPlayerVisibility() {
    final shouldShow = currentVerse.value != null &&
        (_player.processingState != ProcessingState.idle);

    if (showAudioPlayer.value != shouldShow) {
      showAudioPlayer.value = shouldShow;
    }
  }

  /// ────────────────────────────
  /// DISPOSE
  /// ────────────────────────────
  Future<void> dispose() async {
    await _player.dispose();
  }
}

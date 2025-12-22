import 'dart:async';
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
  final ValueNotifier<bool> showAudioPlayer = ValueNotifier(false);

  /// 🔥 download progress (0 → 1)
  final ValueNotifier<double> downloadProgress = ValueNotifier(0);

  final ValueNotifier<bool> autoPlayNext = ValueNotifier(true);
  final ValueNotifier<bool> animateToCurrentVerse = ValueNotifier(false);

  /// avoid double downloads
  final Set<String> _activeDownloads = {};

  final ValueNotifier<String?> uiMessage = ValueNotifier(null);

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

    service._player.playerStateStream.listen((state) {
      service.playing.value = state.playing;
    });

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

  void _notifyError(String message) {
    uiMessage.value = message;
  }

  Future<void> _downloadVerse(Verse verse) async {
    final key = "${currentReciter.value!.identifier}-${verse.id}";
    if (_activeDownloads.contains(key)) return;

    _activeDownloads.add(key);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final folder = "${dir.path}/audio/${currentReciter.value!.identifier}";
      await Directory(folder).create(recursive: true);

      final filePath = "$folder/${verse.id}.mp3";
      final file = File(filePath);

      if (!await file.exists()) {
        final client = http.Client();

        final request = http.Request(
          "GET",
          Uri.parse(getVerseUrl(verse)),
        );

        final res = await client.send(request).timeout(
              const Duration(seconds: 10),
            );

        if (res.statusCode != 200) {
          throw const HttpException("Download failed");
        }

        final sink = file.openWrite();
        await for (final chunk in res.stream) {
          sink.add(chunk);
        }

        await sink.close();
        client.close();
      }

      final audio = VerseAudio()
        ..reciterIdentifier = currentReciter.value!.identifier
        ..surahId = verse.surahNumber
        ..verseId = verse.verseNumber
        ..filePath = filePath;

      await isar.writeTxn(() async {
        await isar.verseAudios.put(audio);
      });
    } on SocketException {
      _notifyError("❌ No internet connection");
    } on TimeoutException {
      _notifyError("⏳ Connection timeout");
    } catch (e) {
      _notifyError("⚠️ Download failed");
      debugPrint("Download error: $e");
    } finally {
      _activeDownloads.remove(key);
    }
  }

  /// ────────────────────────────
  /// PLAYBACK (⚡ STREAM FIRST)
  /// ────────────────────────────
  Future<void> playVerse(Verse verse) async {
    currentVerse.value = verse;
    _syncVisibilityWithVerse();

    try {
      final cached = await getCachedAudio(verse);

      if (cached != null) {
        await _player.setFilePath(cached.filePath);
      } else {
        await _player.setUrl(getVerseUrl(verse));
        _downloadVerse(verse);
      }

      await _player.play();
      _prefetchNextBatch();
    } on SocketException {
      _notifyError("❌ No internet connection");
    } catch (e) {
      _notifyError("⚠️ Failed to play audio");
      debugPrint("Play error: $e");
    }
  }

  Future<void> playNextVerse() async {
    if (currentVerse.value == null) return;

    final surah = await SurahDatabase.getSurah(
      currentVerse.value!.surahNumber,
    );

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
    if (!autoPlayNext.value || currentVerse.value == null) {
      stop();
      return;
    }
    await playNextVerse();
  }

  /// ────────────────────────────
  /// 🔥 PREFETCH NEXT 3 VERSES
  /// ────────────────────────────
  Future<void> _prefetchNextBatch() async {
    if (currentVerse.value == null) return;

    final surah = await SurahDatabase.getSurah(currentVerse.value!.surahNumber);

    for (int i = 1; i <= 3; i++) {
      final next = currentVerse.value!.verseNumber + i;
      if (next > surah!.versesCount) break;

      final v = await SurahDatabase.getVerseQcf(
        currentVerse.value!.surahNumber,
        next,
      );

      if (await getCachedAudio(v) == null) {
        _downloadVerse(v);
      }
    }
  }

  /// ────────────────────────────
  /// CONTROLS
  /// ────────────────────────────
  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> seek(Duration d) => _player.seek(d);

  Future<void> stop() async {
    await _player.stop();
    currentVerse.value = null;
    _syncVisibilityWithVerse(); // ✅ hides once
  }

  void toggleRepeatVerse() {
    repeatVerse.value = !repeatVerse.value;
  }

  void toggleAutoPlay() {
    autoPlayNext.value = !autoPlayNext.value;
  }

  void toggleAnimtingVerse() {
    animateToCurrentVerse.value = !animateToCurrentVerse.value;
  }

  /// ────────────────────────────
  /// UI VISIBILITY
  /// ────────────────────────────
  void _syncVisibilityWithVerse() {
    final shouldShow = currentVerse.value != null;
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

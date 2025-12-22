import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

import '../services/audio_service.dart';
import '../utils/utils.dart';

class MyAudioPlayer extends StatelessWidget {
  const MyAudioPlayer({super.key});

  static String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;

    return RepaintBoundary(
      child: _playerBody(context, audio),
    );
  }
}

Widget _playerBody(BuildContext context, AudioService audio) {
  return Column(
    children: [
      _seekSlider(context, audio),
      SizedBox(height: 10.h),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            _infoRow(audio),
            _controller(audio),
          ],
        ),
      ),
    ],
  );
}

Widget _controller(AudioService audio) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ValueListenableBuilder<bool>(
        valueListenable: audio.repeatVerse,
        builder: (_, repeat, __) {
          return IconButton(
            icon: Icon(
              Icons.repeat_one_rounded,
              color: repeat ? Colors.white : Colors.white70,
            ),
            onPressed: audio.toggleRepeatVerse,
          );
        },
      ),

      IconButton(
        iconSize: 44,
        color: Colors.white,
        icon: const Icon(Icons.skip_previous_rounded),
        onPressed: audio.playPreviousVerse,
      ),
      const SizedBox(width: 6),
      ValueListenableBuilder<bool>(
        valueListenable: audio.playing,
        builder: (_, playing, __) {
          return IconButton(
            iconSize: 44,
            color: Colors.white,
            icon: Icon(
              playing
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
            ),
            onPressed: playing ? audio.pause : audio.resume,
          );
        },
      ),
      const SizedBox(width: 6),
      IconButton(
        iconSize: 44,
        color: Colors.white,
        icon: const Icon(Icons.skip_next_rounded),
        onPressed: audio.playNextVerse,
      ),

      /// Verse info
      ValueListenableBuilder(
        valueListenable: audio.currentVerse,
        builder: (_, verse, __) {
          if (verse == null) return const SizedBox();

          return Text(
            "${verse.surahName}:${verse.verseNumber.toArabicDigits()}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          );
        },
      ),
    ],
  );
}

Widget _infoRow(AudioService audio) {
  return Center(
    child: ValueListenableBuilder(
      valueListenable: audio.currentReciter,
      builder: (_, reciter, __) {
        return Text(
          reciter?.name ?? "—",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
          ),
        );
      },
    ),
  );
}

Widget _seekSlider(BuildContext context, AudioService audio) {
  final scheme = Theme.of(context).colorScheme;
  return Container(
    height: 56.h,
    padding: EdgeInsets.symmetric(horizontal: 12.h),
    decoration: BoxDecoration(
      color: scheme.secondary,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: StreamBuilder<PositionData>(
      stream: Rx.combineLatest2(
        audio.positionStream,
        audio.durationStream,
        (pos, dur) => PositionData(
          pos,
          dur ?? Duration.zero,
        ),
      ),
      builder: (_, snap) {
        final data = snap.data ?? PositionData(Duration.zero, Duration.zero);

        double max =
            data.duration.inMilliseconds.toDouble().clamp(1, double.infinity);
        final pos =
            data.position.inMilliseconds.clamp(0, max.toInt()).toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              MyAudioPlayer._fmt(data.position).toArabicDigits(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: pos,
                  max: max,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                  onChanged: (v) => audio.seek(
                    Duration(milliseconds: v.toInt()),
                  ),
                ),
              ),
            ),
            Text(
              MyAudioPlayer._fmt(data.duration).toArabicDigits(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ],
        );
      },
    ),
  );
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}

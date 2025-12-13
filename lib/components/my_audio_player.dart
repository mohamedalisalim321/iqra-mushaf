import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key});

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  final audioService = AudioService.instance;

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(18),
      color: theme.colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ───────────── Reciter Name ─────────────
            ValueListenableBuilder(
              valueListenable: audioService.reciter,
              builder: (_, reciter, __) {
                return Text(
                  reciter?.name ?? "No reciter selected",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                );
              },
            ),

            const SizedBox(height: 4),

            /// ───────────── Verse Info ─────────────
            ValueListenableBuilder(
              valueListenable: audioService.currentVerse,
              builder: (_, verse, __) {
                if (verse == null) return const SizedBox();
                return Text(
                  "Surah ${verse.surahNumber} • Ayah ${verse.verseNumber}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            /// ───────────── Slider ─────────────
            StreamBuilder<Duration>(
              stream: audioService.positionStream,
              builder: (_, posSnap) {
                final position = posSnap.data ?? Duration.zero;

                return StreamBuilder<Duration?>(
                  stream: audioService.durationStream,
                  builder: (_, durSnap) {
                    final duration = durSnap.data ?? Duration.zero;

                    final max = duration.inMilliseconds.toDouble();
                    final value =
                        position.inMilliseconds.toDouble().clamp(0, max);

                    return Column(
                      children: [
                        Slider(
                          value: max > 0 ? value.toDouble() : 0,
                          max: max > 0 ? max : 1,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white30,
                          onChanged: (v) {
                            audioService.seek(
                              Duration(milliseconds: v.toInt()),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _fmt(position),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _fmt(duration),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 8),

            /// ───────────── Controls ─────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Play / Pause
                ValueListenableBuilder(
                  valueListenable: audioService.playing,
                  builder: (_, isPlaying, __) {
                    return IconButton(
                      iconSize: 56,
                      splashRadius: 30,
                      color: Colors.white,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_fill_rounded,
                      ),
                      onPressed: () {
                        isPlaying
                            ? audioService.pause()
                            : audioService.resume();
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import '../services/audio_service.dart';

// class MyAudioPlayer extends StatefulWidget {
//   const MyAudioPlayer({super.key});

//   @override
//   State<MyAudioPlayer> createState() => _MyAudioPlayerState();
// }

// class _MyAudioPlayerState extends State<MyAudioPlayer> {
//   final audioService = AudioService.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).colorScheme.secondary,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           /// ---------------- Reciter Name ----------------
//           ValueListenableBuilder(
//             valueListenable: audioService.reciter,
//             builder: (_, reciter, __) {
//               return Text(
//                 reciter?.name ?? "No reciter selected",
//                 key: ValueKey(reciter?.id ?? "no_reciter"),
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                 ),
//               );
//             },
//           ),

//           /// ---------------- Slider + Duration ----------------
//           StreamBuilder<Duration>(
//             stream: audioService.positionStream,
//             builder: (_, posSnapshot) {
//               final position = posSnapshot.data ?? Duration.zero;

//               return StreamBuilder<Duration?>(
//                 stream: audioService.durationStream,
//                 builder: (_, durSnapshot) {
//                   final duration = durSnapshot.data ?? Duration.zero;

//                   final maxValue = duration.inMilliseconds.toDouble();
//                   final currentValue = position.inMilliseconds.toDouble();

//                   return Row(
//                     children: [
//                       Text(
//                         _fmt(position),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Slider(
//                           value: currentValue.clamp(0, maxValue),
//                           max: maxValue > 0 ? maxValue : 1,
//                           onChanged: (value) {
//                             audioService.seek(
//                               Duration(milliseconds: value.toInt()),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         _fmt(duration),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),

//           /// ---------------- Play / Pause / Speed ----------------
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               /// Play/Pause Button
//               ValueListenableBuilder(
//                 valueListenable: audioService.playing,
//                 builder: (_, isPlaying, __) {
//                   return IconButton(
//                     iconSize: 50,
//                     color: Colors.white,
//                     splashRadius: 32,
//                     onPressed: () {
//                       isPlaying ? audioService.pause() : audioService.resume();
//                     },
//                     icon: Icon(
//                       isPlaying
//                           ? Icons.pause_circle_filled_rounded
//                           : Icons.play_circle_fill_rounded,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String _fmt(Duration d) {
//     String two(int n) => n.toString().padLeft(2, '0');
//     return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
//   }
// }

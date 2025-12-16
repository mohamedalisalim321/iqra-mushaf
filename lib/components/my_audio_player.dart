import 'package:flutter/material.dart';
import 'package:iqra/utils/utils.dart';

import '../services/audio_service.dart';

class MyAudioPlayer extends StatelessWidget {
  const MyAudioPlayer({super.key});

  static String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService.instance;
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
            /// ───────────── Header ─────────────
            Row(
              children: [
                IconButton(
                  iconSize: 42,
                  color: Colors.white,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: audioService.stop, // ✅ correct behavior
                ),
                const SizedBox(width: 8),

                /// Reciter name
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: audioService.currentReciter,
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
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// ───────────── Progress ─────────────
            StreamBuilder<Duration>(
              stream: audioService.positionStream,
              builder: (_, posSnap) {
                final position = posSnap.data ?? Duration.zero;

                return StreamBuilder<Duration?>(
                  stream: audioService.durationStream,
                  builder: (_, durSnap) {
                    final duration = durSnap.data ?? Duration.zero;

                    final maxMs = duration.inMilliseconds;
                    final posMs = position.inMilliseconds.clamp(0, maxMs);

                    return Row(
                      children: [
                        Text(
                          _fmt(position).toArabicDigits(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Slider(
                            value: maxMs > 0 ? posMs.toDouble() : 0,
                            max: maxMs > 0 ? maxMs.toDouble() : 1,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white30,
                            onChanged: (v) {
                              audioService.seek(
                                Duration(milliseconds: v.toInt()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _fmt(duration).toArabicDigits(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
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
                IconButton(
                  iconSize: 56,
                  color: Colors.white,
                  onPressed: () => audioService.playNextVerse(),
                  icon: Icon(Icons.arrow_circle_right_outlined),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: audioService.playing,
                  builder: (_, isPlaying, __) {
                    return IconButton(
                      iconSize: 56,
                      color: Colors.white,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_fill_rounded,
                      ),
                      onPressed:
                          isPlaying ? audioService.pause : audioService.resume,
                    );
                  },
                ),
                IconButton(
                  iconSize: 56,
                  color: Colors.white,
                  onPressed: () => audioService.playPreviousVerse(),
                  icon: Icon(Icons.arrow_circle_left_outlined),
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
// import 'package:iqra/utils/utils.dart';

// import '../services/audio_service.dart';

// class MyAudioPlayer extends StatefulWidget {
//   const MyAudioPlayer({super.key});

//   @override
//   State<MyAudioPlayer> createState() => _MyAudioPlayerState();
// }

// class _MyAudioPlayerState extends State<MyAudioPlayer> {
//   final audioService = AudioService.instance;

//   String _fmt(Duration d) {
//     String two(int n) => n.toString().padLeft(2, '0');
//     return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Material(
//       elevation: 12,
//       borderRadius: BorderRadius.circular(18),
//       color: theme.colorScheme.secondary,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   iconSize: 56,
//                   color: Colors.white,
//                   onPressed: () => audioService.toggleShowAudioPlayer(),
//                   icon: Icon(Icons.close_rounded),
//                 ),

//                 /// ───────────── Reciter Name ─────────────

//                 ValueListenableBuilder(
//                   valueListenable: audioService.reciter,
//                   builder: (_, reciter, __) {
//                     return Text(
//                       reciter?.name ?? "No reciter selected",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),

//             /// ───────────── Slider ─────────────
//             StreamBuilder<Duration>(
//               stream: audioService.positionStream,
//               builder: (_, posSnap) {
//                 final position = posSnap.data ?? Duration.zero;

//                 return StreamBuilder<Duration?>(
//                   stream: audioService.durationStream,
//                   builder: (_, durSnap) {
//                     final duration = durSnap.data ?? Duration.zero;

//                     final max = duration.inMilliseconds.toDouble();
//                     final value =
//                         position.inMilliseconds.toDouble().clamp(0, max);

//                     return Row(
//                       children: [
//                         Text(
//                           _fmt(position).toArabicDigits(),
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         Expanded(
//                           child: Slider(
//                             value: max > 0 ? value.toDouble() : 0,
//                             max: max > 0 ? max : 1,
//                             activeColor: Colors.white,
//                             inactiveColor: Colors.white30,
//                             onChanged: (v) {
//                               audioService.seek(
//                                 Duration(milliseconds: v.toInt()),
//                               );
//                             },
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         Text(
//                           _fmt(duration).toArabicDigits(),
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),

//             /// ───────────── Controls ─────────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 /// Play / Pause
//                 ValueListenableBuilder(
//                   valueListenable: audioService.playing,
//                   builder: (_, isPlaying, __) {
//                     return IconButton(
//                       iconSize: 56,
//                       color: Colors.white,
//                       icon: Icon(
//                         isPlaying
//                             ? Icons.pause_circle_filled_rounded
//                             : Icons.play_circle_fill_rounded,
//                       ),
//                       onPressed: () {
//                         isPlaying
//                             ? audioService.pause()
//                             : audioService.resume();
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

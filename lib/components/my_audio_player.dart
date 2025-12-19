import 'package:flutter/material.dart';

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
    return ValueListenableBuilder<bool>(
      valueListenable: audio.showAudioPlayer,
      builder: (_, visible, __) {
        if (!visible) return const SizedBox.shrink();

        return IgnorePointer(
          ignoring: !visible,
          child: AnimatedSlide(
            offset: visible ? Offset.zero : const Offset(0, 1),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: RepaintBoundary(child: _playerBody(context, audio)),
            ),
          ),
        );
      },
    );
  }

  Column _playerBody(BuildContext context, AudioService audio) {
    return Column(
      children: [
        Row(
          children: [

            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: StreamBuilder<Duration>(
                stream: audio.positionStream,
                builder: (_, posSnap) {
                  final position = posSnap.data ?? Duration.zero;

                  return StreamBuilder<Duration?>(
                    stream: audio.durationStream,
                    builder: (_, durSnap) {
                      final duration = durSnap.data ?? Duration.zero;

                      final maxMs = duration.inMilliseconds;
                      final posMs = position.inMilliseconds.clamp(0, maxMs);

                      return Expanded(
                        child: Slider(
                          value: maxMs > 0 ? posMs.toDouble() : 0,
                          max: maxMs > 0 ? maxMs.toDouble() : 1,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white30,
                          onChanged: (v) => audio.seek(
                            Duration(milliseconds: v.toInt()),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),


            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.settings),
            ),

            


          ],
        ),
        const SizedBox(height: 10),
        Container(
          // height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder(
                    stream: audio.positionStream,
                    builder: (_, posSnap) {
                      final position = posSnap.data ?? Duration.zero;
                      return Text(
                        _fmt(position).toArabicDigits(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: audio.currentReciter,
                    builder: (_, reciter, __) {
                      return Text(
                        reciter?.name ?? "—",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: audio.durationStream,
                    builder: (_, durSnap) {
                      final duration = durSnap.data ?? Duration.zero;
                      return Text(
                        _fmt(duration).toArabicDigits(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
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

                  //                       /// Verse info
                  ValueListenableBuilder(
                    valueListenable: audio.currentVerse,
                    builder: (_, verse, __) {
                      if (verse == null) return const SizedBox();

                      return Text(
                        "${verse.surahName} : ${verse.verseNumber.toArabicDigits()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// import '../services/audio_service.dart';
// import '../utils/utils.dart';

// class MyAudioPlayer extends StatelessWidget {
//   const MyAudioPlayer({super.key});

//   static String _fmt(Duration d) {
//     String two(int n) => n.toString().padLeft(2, '0');
//     return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final audio = AudioService.instance;
//     final theme = Theme.of(context);

//     return ValueListenableBuilder<bool>(
//       valueListenable: audio.showAudioPlayer,
//       builder: (_, visible, __) {
//         if (!visible) return const SizedBox.shrink();

//         return IgnorePointer(
//           ignoring: !visible,
//           child: AnimatedSlide(
//             offset: visible ? Offset.zero : const Offset(0, 1),
//             duration: const Duration(milliseconds: 200),
//             curve: Curves.easeOutCubic,
//             child: AnimatedOpacity(
//               opacity: visible ? 1 : 0,
//               duration: const Duration(milliseconds: 180),
//               child: RepaintBoundary(child: playerBody(theme, audio)),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget playerBody(ThemeData theme, AudioService audio) {
//     return Material(
//       elevation: 14,
//       borderRadius: BorderRadius.circular(18),
//       color: theme.colorScheme.secondary,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             /// ───────── Header ─────────
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.close_rounded),
//                   iconSize: 34,
//                   color: Colors.white,
//                   onPressed: audio.stop,
//                 ),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// Reciter
//                       ValueListenableBuilder(
//                         valueListenable: audio.currentReciter,
//                         builder: (_, reciter, __) {
//                           return Text(
//                             reciter?.name ?? "—",
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 15,
//                             ),
//                           );
//                         },
//                       ),

//                       /// Verse info
//                       ValueListenableBuilder(
//                         valueListenable: audio.currentVerse,
//                         builder: (_, verse, __) {
//                           if (verse == null) return const SizedBox();

//                           return Text(
//                             "سورة ${verse.surahName} • آية ${verse.verseNumber.toArabicDigits()}",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 ValueListenableBuilder<bool>(
//                   valueListenable: audio.repeatVerse,
//                   builder: (_, repeat, __) {
//                     return IconButton(
//                       icon: Icon(
//                         Icons.repeat_one_rounded,
//                         color: repeat ? Colors.white : Colors.white70,
//                       ),
//                       onPressed: audio.toggleRepeatVerse,
//                     );
//                   },
//                 ),
//               ],
//             ),

//             /// ───────── Progress ─────────
//             StreamBuilder<Duration>(
//               stream: audio.positionStream,
//               builder: (_, posSnap) {
//                 final position = posSnap.data ?? Duration.zero;

//                 return StreamBuilder<Duration?>(
//                   stream: audio.durationStream,
//                   builder: (_, durSnap) {
//                     final duration = durSnap.data ?? Duration.zero;

//                     final maxMs = duration.inMilliseconds;
//                     final posMs = position.inMilliseconds.clamp(0, maxMs);

//                     return Row(
//                       children: [
//                         Text(
//                           _fmt(position).toArabicDigits(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                         ),
//                         Expanded(
//                           child: Slider(
//                             value: maxMs > 0 ? posMs.toDouble() : 0,
//                             max: maxMs > 0 ? maxMs.toDouble() : 1,
//                             activeColor: Colors.white,
//                             inactiveColor: Colors.white30,
//                             onChanged: (v) => audio.seek(
//                               Duration(milliseconds: v.toInt()),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           _fmt(duration).toArabicDigits(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),

//             /// ───────── Controls ─────────
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   iconSize: 44,
//                   color: Colors.white,
//                   icon: const Icon(Icons.skip_previous_rounded),
//                   onPressed: audio.playPreviousVerse,
//                 ),
//                 const SizedBox(width: 6),
//                 ValueListenableBuilder<bool>(
//                   valueListenable: audio.playing,
//                   builder: (_, playing, __) {
//                     return IconButton(
//                       iconSize: 44,
//                       color: Colors.white,
//                       icon: Icon(
//                         playing
//                             ? Icons.pause_circle_filled_rounded
//                             : Icons.play_circle_fill_rounded,
//                       ),
//                       onPressed: playing ? audio.pause : audio.resume,
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 6),
//                 IconButton(
//                   iconSize: 44,
//                   color: Colors.white,
//                   icon: const Icon(Icons.skip_next_rounded),
//                   onPressed: audio.playNextVerse,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

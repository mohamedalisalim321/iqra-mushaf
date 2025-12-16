import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../models/quran/verse.dart';
import '../../services/audio_service.dart';
import '../my_audio_player.dart';
import 'quran_page.dart';

class SurahQuran extends StatefulWidget {
  final PageController pageController;
  final ValueChanged<int>? onPageChanged;
  final void Function()? onQuranPageNumber;

  final Verse? selectedVerse;
  final Verse? playingVerse;

  final void Function(Verse verse, Offset tapPosition)? onVerseTap;

  const SurahQuran({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.onQuranPageNumber,
    required this.onVerseTap,
    required this.selectedVerse,
    required this.playingVerse,
  });

  @override
  State<SurahQuran> createState() => _SurahQuranState();
}

class _SurahQuranState extends State<SurahQuran> {
  final AudioService audioService = AudioService.instance;

  /// Keep recognizers per page (NOT recreated every rebuild)
  final Map<int, List<GestureRecognizer>> _pageRecognizers = {};

  @override
  void dispose() {
    for (final list in _pageRecognizers.values) {
      for (final r in list) {
        r.dispose();
      }
    }
    _pageRecognizers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: widget.pageController,
          itemCount: 604,
          onPageChanged: widget.onPageChanged,
          itemBuilder: (_, index) {
            final page = index + 1;
            return QuranPage(
              page: page,
              selectedVerse: widget.selectedVerse,
              playingVerse: widget.playingVerse,
              onVerseTap: widget.onVerseTap,
              onQuranPageNumber: widget.onQuranPageNumber,
              recognizers: _pageRecognizers.putIfAbsent(page, () => []),
            );
          },
        ),

        // 🔊 Audio player overlay (isolated rebuild)
        ValueListenableBuilder<bool>(
          valueListenable: audioService.showAudioPlayer,
          builder: (_, show, __) {
            if (!show) return const SizedBox.shrink();
            return const Padding(
              padding: EdgeInsets.all(12),
              child: MyAudioPlayer(),
            );
          },
        ),
      ],
    );
  }
}

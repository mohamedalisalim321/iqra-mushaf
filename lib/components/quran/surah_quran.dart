import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../models/quran/verse.dart';
import '../../services/audio_service.dart';
import 'quran_page.dart';

class SurahQuran extends StatefulWidget {
  final PageController pageController;
  final ValueChanged<int>? onPageChanged;

  final Verse? selectedVerse;
  final Verse? playingVerse;

  final void Function(Verse verse)? onVerseTap;

  const SurahQuran({
    super.key,
    required this.pageController,
    required this.onPageChanged,
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
    return PageView.builder(
      controller: widget.pageController,
      scrollDirection: Axis.horizontal,
      itemCount: 604,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (_, index) {
        final page = index + 1;
        return QuranPage(
          page: page,
          selectedVerse: widget.selectedVerse,
          playingVerse: widget.playingVerse,
          onVerseTap: widget.onVerseTap,
          recognizers: _pageRecognizers.putIfAbsent(page, () => []),
        );
      },
    );
  }
}

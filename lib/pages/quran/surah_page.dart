import 'package:flutter/material.dart';

import '../../components/my_audio_player.dart';
import '../../components/quran/surah_quran.dart';
import '../../components/quran/verse_bottom_sheet.dart';
import '../../database/surah_database.dart';
import '../../models/quran/verse.dart';
import '../../services/audio_service.dart';

class SurahPage extends StatefulWidget {
  final int pageNumber;

  const SurahPage({
    super.key,
    required this.pageNumber,
  });

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final AudioService audio = AudioService.instance;

  late final PageController _pageController;
  late int _currentPage;

  /// Fine-grained state (NO setState rebuilds)
  final ValueNotifier<Verse?> _selectedVerse = ValueNotifier(null);
  final ValueNotifier<Verse?> _playingVerse = ValueNotifier(null);
  final ValueNotifier<bool> _showAppBar = ValueNotifier(false);

  // ─────────────────────────────
  // Lifecycle
  // ─────────────────────────────

  @override
  void initState() {
    super.initState();

    _currentPage = widget.pageNumber.clamp(1, 604);
    _pageController = PageController(initialPage: _currentPage - 1);

    audio.currentVerse.addListener(_onVerseChanged);
  }

  @override
  void dispose() {
    audio.currentVerse.removeListener(_onVerseChanged);

    _selectedVerse.dispose();
    _playingVerse.dispose();
    _showAppBar.dispose();

    _pageController.dispose();
    super.dispose();
  }

  // ─────────────────────────────
  // Audio sync (NO rebuilds)
  // ─────────────────────────────

  void _onVerseChanged() {
    final verse = audio.currentVerse.value;
    if (verse == null) return;

    if (_playingVerse.value?.id == verse.id) return;

    _playingVerse.value = verse;
    _selectedVerse.value = verse;

    final page = SurahDatabase.getPageNumber(
      verse.surahNumber,
      verse.verseNumber,
    ).clamp(1, 604);

    if (page != _currentPage) {
      _pageController.animateToPage(
        page - 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // ─────────────────────────────
  // Verse actions
  // ─────────────────────────────

  void _showVerseSheet(Verse verse) {
    if (_selectedVerse.value?.id != verse.id) {
      _selectedVerse.value = verse;
    }
    _showAppBar.value = false;
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.25),
      builder: (_) => VerseBottomSheet(verse: verse),
    );
  }
  // ─────────────────────────────
  // Page handling
  // ─────────────────────────────

  void _handlePageChanged(int index) {
    final page = index + 1;
    if (_currentPage == page) return;

    _currentPage = page;
    _selectedVerse.value = null;
    // _showAppBar.value = false;
  }

  // ─────────────────────────────
  // UI
  // ─────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Quran content + gestures
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _showAppBar.value = !_showAppBar.value;
              },
              child: ValueListenableBuilder<Verse?>(
                valueListenable: _selectedVerse,
                builder: (_, selectedVerse, __) {
                  return ValueListenableBuilder<Verse?>(
                    valueListenable: _playingVerse,
                    builder: (_, playingVerse, __) {
                      return SurahQuran(
                        pageController: _pageController,
                        selectedVerse: selectedVerse,
                        playingVerse: playingVerse,
                        onVerseTap: _showVerseSheet,
                        onPageChanged: _handlePageChanged,
                      );
                    },
                  );
                },
              ),
            ),

            // 🎵 Audio player (does NOT toggle AppBar)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: _myAudioPlayer(),
            ),

            // ⬆️ Floating AppBar
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: _floatingAppBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myAudioPlayer() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showAppBar,
      builder: (_, visible, __) {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : const Offset(0, 1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: visible ? 1 : 0,
            child: const MyAudioPlayer(),
          ),
        );
      },
    );
  }

  Widget _floatingAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: _showAppBar,
        builder: (_, visible, __) {
          return AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            offset: visible ? Offset.zero : const Offset(0, -1),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: visible ? 1 : 0,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

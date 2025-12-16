import 'package:flutter/material.dart';

import '../../components/quran/surah_quran.dart';
import '../../components/quran/verse_bottom_sheet.dart';
import '../../database/surah_database.dart';
import '../../models/quran/verse.dart';
import '../../services/audio_service.dart';
import '../../utils/utils.dart';

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
  final AudioService audioService = AudioService.instance;

  late final PageController _pageController;
  late int _currentPage;

  // 🔥 Fine-grained state (NO setState rebuilds)
  final ValueNotifier<Verse?> _selectedVerse = ValueNotifier(null);
  final ValueNotifier<Verse?> _playingVerse = ValueNotifier(null);
  final ValueNotifier<bool> _showAudioPlayer = ValueNotifier(false);

  // ──────────────────────────────────────────────
  // Lifecycle
  // ──────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _currentPage = widget.pageNumber.clamp(1, 604);
    _pageController = PageController(initialPage: _currentPage - 1);

    audioService.playing.addListener(_onPlayingChanged);
    audioService.currentVerse.addListener(_onVerseChanged);
  }

  @override
  void dispose() {
    audioService.playing.removeListener(_onPlayingChanged);
    audioService.currentVerse.removeListener(_onVerseChanged);

    _selectedVerse.dispose();
    _playingVerse.dispose();
    _showAudioPlayer.dispose();

    _pageController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // Audio listeners (NO setState)
  // ──────────────────────────────────────────────

  void _onPlayingChanged() {
    final isPlaying = audioService.playing.value;
    if (_showAudioPlayer.value != isPlaying) {
      _showAudioPlayer.value = isPlaying;
    }
  }

  void _onVerseChanged() {
    final verse = audioService.currentVerse.value;
    if (verse == null) return;

    // Prevent duplicate rebuilds
    if (_playingVerse.value?.id == verse.id) return;

    _playingVerse.value = verse;
    _selectedVerse.value = verse;

    final versePage = SurahDatabase.getPageNumber(
      verse.surahNumber,
      verse.verseNumber,
    );

    if (versePage != _currentPage) {
      _pageController.animateToPage(
        versePage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // ──────────────────────────────────────────────
  // Verse actions
  // ──────────────────────────────────────────────

  void _playVerse(Verse verse) {
    audioService.playVerse(verse);
  }

  void _showVerseSheet(Verse verse) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.25),
      barrierColor: Colors.black54,
      builder: (_) => VerseBottomSheet(verse: verse),
    );
  }

  void _showVerseMenu(
    BuildContext context,
    Verse verse,
    Offset tapPosition,
  ) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: const Text('Play verse'),
          onTap: () => Future.microtask(() => _playVerse(verse)),
        ),
        PopupMenuItem(
          child: const Text('Verse info'),
          onTap: () => Future.microtask(() => _showVerseSheet(verse)),
        ),
      ],
    );
  }

  void _handleVerseTap(Verse verse, Offset tapPosition) {
    if (_selectedVerse.value?.id != verse.id) {
      _selectedVerse.value = verse;
    }

    _showVerseMenu(context, verse, tapPosition);
  }

  // ──────────────────────────────────────────────
  // Page handling
  // ──────────────────────────────────────────────

  void _handlePageChanged(int index) {
    final newPage = index + 1;
    if (_currentPage == newPage) return;

    _currentPage = newPage;
    _selectedVerse.value = null;
  }

  void _onQuranPageNumberTapped() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: 603,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text((index + 1).toArabicDigits()),
              onTap: () {
                Navigator.pop(context);
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
            );
          },
        );
      },
    );
  }

  // ──────────────────────────────────────────────
  // UI (Scaffold NEVER rebuilds)
  // ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
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
                  onVerseTap: _handleVerseTap,
                  onPageChanged: _handlePageChanged,
                  onQuranPageNumber: _onQuranPageNumberTapped,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

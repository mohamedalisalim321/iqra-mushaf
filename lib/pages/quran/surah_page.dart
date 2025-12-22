import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/my_audio_player.dart';
import '../../components/my_searchbar.dart';
import '../../components/quran/quran_page.dart';
import '../../components/quran/verse_bottom_sheet.dart';
import '../../components/quran/verse_tile.dart';
import '../../components/settings_sheet.dart';
import '../../database/surah_database.dart';
import '../../models/quran/verse.dart';
import '../../services/audio_service.dart';

class SurahPage extends StatefulWidget {
  final int pageNumber;

  const SurahPage({super.key, required this.pageNumber});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final AudioService audio = AudioService.instance;
  final TextEditingController _searchCont = TextEditingController();

  late final PageController _pageController;
  late int _currentPage;

  final ValueNotifier<Verse?> _selectedVerse = ValueNotifier(null);
  final ValueNotifier<Verse?> _playingVerse = ValueNotifier(null);
  final ValueNotifier<bool> _showAppBar = ValueNotifier(false);

  Timer? _searchDebounce;

  bool _isUserScrolling = false;
  DateTime _lastToggle = DateTime.fromMillisecondsSinceEpoch(0);

  List<Verse> _filteredVerses = [];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageNumber.clamp(1, 604);
    _pageController = PageController(initialPage: _currentPage - 1);

    audio.currentVerse.addListener(_onVerseChanged);

    AudioService.instance.uiMessage.addListener(() {
      final msg = AudioService.instance.uiMessage.value;
      if (msg == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );

      // clear message
      AudioService.instance.uiMessage.value = null;
    });
  }

  @override
  void dispose() {
    audio.currentVerse.removeListener(_onVerseChanged);

    _selectedVerse.dispose();
    _playingVerse.dispose();
    _showAppBar.dispose();
    _pageController.dispose();
    _searchCont.dispose();
    super.dispose();
  }

  // ─────────────────────────────
  // Audio sync
  // ─────────────────────────────
  void _onVerseChanged() {
    final verse = audio.currentVerse.value;
    if (verse == null || _playingVerse.value?.id == verse.id) return;

    _playingVerse.value = verse;

    // ❗ only auto-select if user didn't select manually
    _selectedVerse.value ??= verse;

    if (_isUserScrolling) return;

    if (audio.animateToCurrentVerse.value == true) {
      final page =
          SurahDatabase.getPageNumber(verse.surahNumber, verse.verseNumber)
              .clamp(1, 604);
      if (page != _currentPage) {
        _pageController.animateToPage(
          page - 1,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  // ─────────────────────────────
  // UI interactions
  // ─────────────────────────────
  void _toggleOverlays() {
    final now = DateTime.now();
    if (now.difference(_lastToggle).inMilliseconds < 250) return;
    _lastToggle = now;

    HapticFeedback.lightImpact();
    _showAppBar.value = !_showAppBar.value;
  }

  void _showVerseSheet(Verse verse) {
    _selectedVerse.value = verse;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.25),
      builder: (_) => VerseBottomSheet(verse: verse),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.25),
      builder: (_) => const SettingsSheet(),
    );
  }

  void _jumpToVerse(Verse verse) {
    _selectedVerse.value = verse;

    final page = SurahDatabase.getPageNumber(
      verse.surahNumber,
      verse.verseNumber,
    ).clamp(1, 604);

    if (page != _currentPage) {
      _pageController.animateToPage(
        page - 1,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onSearchChanged(
    String value,
    void Function(void Function()) setDialogState,
  ) {
    _searchDebounce?.cancel();

    final query = value.trim();
    if (query.isEmpty) {
      setDialogState(() => _filteredVerses.clear());
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final results = await SurahDatabase.searchVerses(query);
      if (!mounted) return;
      setDialogState(() => _filteredVerses = results);
    });
  }

  Future<void> searchVerses(String query) async {
    final value = query.trim();
    try {
      final results = await SurahDatabase.searchVerses(value);
      if (!mounted) return;
      setState(() => _filteredVerses = results);
    } catch (_) {}
  }

  void _showSearchSheet() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: MySearchbar(
            controller: _searchCont,
            hintText: "أبحث عن آية...",
            onChanged: (v) => _onSearchChanged(v, setDialogState),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 500.h,
            child: ListView.builder(
              itemCount: _filteredVerses.length,
              itemBuilder: (_, index) {
                final verse = _filteredVerses[index];

                return VerseTile(
                  verse: verse,
                  onTap: () {
                    Navigator.pop(context);
                    _jumpToVerse(verse);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handlePageChanged(int index) {
    _currentPage = index + 1;
    _selectedVerse.value = null;
  }

  // ─────────────────────────────
  // UI
  // ─────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggleOverlays,
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  _isUserScrolling = n is ScrollStartNotification ||
                      n is ScrollUpdateNotification;
                  return false;
                },
                child: ValueListenableBuilder2<Verse?, Verse?>(
                  first: _selectedVerse,
                  second: _playingVerse,
                  builder: (_, selected, playing, __) {
                    return SurahQuran(
                      pageController: _pageController,
                      selectedVerse: selected,
                      playingVerse: playing,
                      onVerseTap: _showVerseSheet,
                      onPageChanged: _handlePageChanged,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 8.h,
              left: 8.w,
              right: 8.w,
              child: _animatedOverlay(
                visibleListenable: _showAppBar,
                offsetHidden: const Offset(0, 1),
                child: const MyAudioPlayer(),
              ),
            ),
            Positioned(
              top: 8.h,
              left: 0,
              right: 0,
              child: _animatedOverlay(
                visibleListenable: _showAppBar,
                offsetHidden: const Offset(0, -1),
                child: _buildFloatingAppBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────
  // Shared animation widget
  // ─────────────────────────────
  Widget _animatedOverlay({
    required ValueListenable<bool> visibleListenable,
    required Offset offsetHidden,
    required Widget child,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: visibleListenable,
      builder: (_, visible, __) {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : offsetHidden,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: visible ? 1 : 0,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildFloatingAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: _showSearchSheet,
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: _showSettingsSheet,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper for combining 2 ValueListenables
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (_, b, ___) {
            return builder(context, a, b, null);
          },
        );
      },
    );
  }
}

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
  /// Gesture recognizers cached per page
  final Map<int, List<GestureRecognizer>> _pageRecognizers =
      <int, List<GestureRecognizer>>{};

  static const int _pageCount = 604;

  @override
  void dispose() {
    _disposeAllRecognizers();
    super.dispose();
  }

  void _disposeAllRecognizers() {
    for (final recognizers in _pageRecognizers.values) {
      for (final r in recognizers) {
        r.dispose();
      }
    }
    _pageRecognizers.clear();
  }

  List<GestureRecognizer> _recognizersForPage(int page) {
    return _pageRecognizers.putIfAbsent(page, () => <GestureRecognizer>[]);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      scrollDirection: Axis.horizontal,
      itemCount: _pageCount,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        final int page = index + 1;

        return QuranPage(
          page: page,
          selectedVerse: widget.selectedVerse,
          playingVerse: widget.playingVerse,
          onVerseTap: widget.onVerseTap,
          recognizers: _recognizersForPage(page),
        );
      },
    );
  }
}

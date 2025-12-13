import 'package:flutter/material.dart';
import 'package:iqra/database/surah_database.dart';

import '../../components/quran/verse_bottom_sheet.dart';
import '../../components/quran/surah_quran.dart';
import '../../models/quran/verse.dart';
import '../../services/audio_service.dart';

class SurahPage extends StatefulWidget {
  final int surahIndex;

  const SurahPage({
    super.key,
    required this.surahIndex,
  });

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  late final PageController _pageController;
  final audioService = AudioService.instance;

  Verse? _selectedVerse;
  Verse? _playingVerse;

  bool showAudioPlayer = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _currentPage = widget.surahIndex.clamp(1, 604);
    _pageController = PageController(initialPage: _currentPage - 1);

    /// 🔊 audio playing state
    audioService.playing.addListener(_onPlayingChanged);

    /// 🎧 currently playing verse
    audioService.currentVerse.addListener(_onVerseChanged);
  }

  void _onPlayingChanged() {
    if (!mounted) return;
    setState(() {
      showAudioPlayer = audioService.playing.value;
    });
  }

  void _onVerseChanged() {
    if (!mounted) return;

    final verse = audioService.currentVerse.value;
    if (verse == null) return;

    setState(() {
      _playingVerse = verse;
      _selectedVerse = verse;
    });

    int versePageNumber =
        SurahDatabase.getPageNumber(verse.surahNumber, verse.verseNumber);

    /// 🔥 auto scroll to verse page
    if (versePageNumber != _currentPage) {
      _pageController.animateToPage(
        versePageNumber - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    audioService.playing.removeListener(_onPlayingChanged);
    audioService.currentVerse.removeListener(_onVerseChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _playVerse(Verse verse) async {
    await audioService.playVerse(verse);
  }

  void _showVerseSheet(Verse verse) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.25),
      barrierColor: Colors.black54,
      builder: (_) => VerseBottomSheet(verse: verse),
    );
  }

  void _showVerseMenu(BuildContext context, Verse verse, Offset tapPos) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        tapPos & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: const Text("▶ Play verse"),
          onTap: () => _playVerse(verse),
        ),
        PopupMenuItem(
          child: const Text("📖 Verse info"),
          onTap: () => _showVerseSheet(verse),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SurahQuran(
        pageController: _pageController,
        showAudioPlayer: showAudioPlayer,

        /// 🔥 highlighted verse
        selectedVerse: _selectedVerse,
        playingVerse: _playingVerse,

        onVerseTap: (verse, tapPosition) {
          setState(() => _selectedVerse = verse);
          _showVerseMenu(context, verse, tapPosition);
        },

        onPageChanged: (page) {
          setState(() {
            _currentPage = page + 1;
            _selectedVerse = null;
          });
        },
      ),
    );
  }
}



// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// import '../../components/quran/verse_bottom_sheet.dart';
// import '../../components/quran/surah_quran.dart';
// import '../../models/quran/verse.dart';
// import '../../services/audio_service.dart';

// class SurahPage extends StatefulWidget {
//   final int surahIndex;
//   const SurahPage({super.key, required this.surahIndex});

//   @override
//   State<SurahPage> createState() => _SurahPageState();
// }

// class _SurahPageState extends State<SurahPage>
//     with SingleTickerProviderStateMixin {
//   final List<LongPressGestureRecognizer> _recognizers = [];

//   late PageController _pageController;

//   bool showAudioPlayer = false;

//   Verse? _selectedVerse;
//   int _currentPage = 1;

//   final audioService = AudioService.instance;

//   @override
//   void initState() {
//     super.initState();
//     _safeInit();
//   }

//   Future<void> _safeInit() async {
//     _currentPage = widget.surahIndex.clamp(1, 604);

//     _pageController = PageController(initialPage: _currentPage - 1);

//     audioService.playing.addListener(() {
//       if (mounted) {
//         setState(() {
//           showAudioPlayer = audioService.playing.value;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     for (final r in _recognizers) {
//       r.dispose();
//     }
//     _recognizers.clear();

//     _pageController.dispose();
//     super.dispose();
//   }

//   void _showVerseSheet(Verse verse) {
//     if (!mounted) return;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.black.withOpacity(0.2),
//       barrierColor: Colors.black54,
//       builder: (_) => VerseBottomSheet(
//         verse: verse,
//       ),
//     );
//   }

//   void playVerse(Verse verse) async {
//     await audioService.playVerse(verse);

//     if (!mounted) return;
//     setState(() {
//       showAudioPlayer = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       // body: _buildPageView(),
//       body: SurahQuran(
//         pageController: _pageController,
//         showAudioPlayer: showAudioPlayer,
//         selectedVerse: _selectedVerse,
//         onVerseTap: (verse) => showMenu(
//           context: context,
//           position: RelativeRect.fill,
//           items: [
//             PopupMenuItem(
//               child: const Text("audio"),
//               onTap: () {
//                 playVerse(verse);
//               },
//             ),
//             PopupMenuItem(
//               child: const Text("verse info"),
//               onTap: () {
//                 _showVerseSheet(verse);
//               },
//             ),
//           ],
//         ),
//         onPageChanged: (page) {
//           setState(() {
//             _currentPage = page + 1;
//             _selectedVerse = null;
//           });
//         },
//       ),
//     );
//   }
// }

  // PreferredSizeWidget _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     title: Text(
  //       "صفحة $_currentPage",
  //       style: const TextStyle(
  //         fontSize: 20,
  //       ),
  //     ),
  //     centerTitle: true,
  //   );
  // }

  // Widget _buildPageView() {
  //   return Stack(
  //     children: [
  //       if (showAudioPlayer)
  //         const Align(
  //           alignment: Alignment.bottomCenter,
  //           child: Padding(
  //             padding: EdgeInsets.all(12),
  //             child: MyAudioPlayer(),
  //           ),
  //         ),
  //       PageView.builder(
  //         controller: _pageController,
  //         reverse: false,
  //         itemCount: 604,
  //         onPageChanged: _onPageChanged,
  //         itemBuilder: (_, i) => FutureBuilder<Widget>(
  //           future: _buildPage(i + 1),
  //           builder: (_, s) {
  //             if (s.connectionState == ConnectionState.waiting) {
  //               return const Center(child: CircularProgressIndicator());
  //             }
  //             if (s.hasError) return _buildErrorPage(i + 1);
  //             return s.data ?? const SizedBox();
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildErrorPage(int page) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Icon(Icons.error, size: 70, color: Colors.red[400]),
  //       const SizedBox(height: 10),
  //       Text(
  //         "تعذّر تحميل الصفحة $page",
  //         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //       ),
  //       TextButton.icon(
  //         onPressed: () => setState(() => _pageCache.remove(page)),
  //         icon: const Icon(Icons.refresh),
  //         label: const Text("إعادة المحاولة"),
  //       ),
  //     ],
  //   );
  // }

  // void _onPageChanged(int page) {
  //   setState(() {
  //     _currentPage = page + 1;
  //     _selectedVerse = null;
  //   });
  // }

  // Future<Widget> _buildPage(int page) async {
  //   final ranges = SurahDatabase.getPageData(page);
  //   final font = "QCF_P${page.toString().padLeft(3, '0')}";
  //   final fontSize = getFontSize(page, context).sp;

  //   final spans = <InlineSpan>[];

  //   if (page <= 2) {
  //     spans.add(WidgetSpan(child: SizedBox(height: 110.h)));
  //   }

  //   // dispose old recognizers
  //   for (final r in _recognizers) {
  //     r.dispose();
  //   }
  //   _recognizers.clear();

  //   for (final r in ranges) {
  //     await _addRange(spans, r, page, font);
  //   }

  //   final widget = RichText(
  //     textDirection: TextDirection.rtl,
  //     textAlign: TextAlign.center,
  //     text: TextSpan(
  //       children: spans,
  //       style: TextStyle(
  //         fontFamily: font,
  //         fontSize: fontSize,
  //         height: 2.h,
  //         color: Colors.black,
  //       ),
  //     ),
  //   );

  //   return widget;
  // }

  // Future<void> _addRange(
  //   List<InlineSpan> spans,
  //   Map<String, int> range,
  //   int page,
  //   String font,
  // ) async {
  //   final surah = range["surah"]!;
  //   final start = range["start"]!;
  //   final end = range["end"]!;

  //   for (int v = start; v <= end; v++) {
  //     if (v == 1 && v == start) {
  //       _addSurahHeader(spans, surah, page);
  //     }

  //     await _addVerse(spans, surah, v, font, isFirst: v == start);
  //   }
  // }

  // void _addSurahHeader(List<InlineSpan> spans, int surah, int page) {
  //   spans.add(
  //     WidgetSpan(
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(vertical: 12.h),
  //         child: SurahHeader(suraNumber: surah),
  //       ),
  //     ),
  //   );

  //   if (page != 1 && page != 187) {
  //     spans.add(
  //       TextSpan(
  //         text: "齃𧻓𥳐龎" + "\n",
  //         style: TextStyle(
  //           fontFamily: "QCF_BSML",
  //           fontSize:
  //               getScreenType(context) == ScreenType.large ? 13.2.sp : 18.sp,
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Future<void> _addVerse(
  //   List<InlineSpan> spans,
  //   int surah,
  //   int verse,
  //   String font, {
  //   required bool isFirst,
  // }) async {
  //   final v = await SurahDatabase.getVerseQcf(surah, verse);

  //   final txt =
  //       isFirst ? "${v.qcfData[0]}\u200A${v.qcfData.substring(1)}" : v.qcfData;

  //   final recognizer = LongPressGestureRecognizer()
  //     ..onLongPress = () {
  //       if (!mounted) return;
  //       setState(() => _selectedVerse = v);

  //       showMenu(
  //         context: context,
  //         position: RelativeRect.fill,
  //         items: [
  //           PopupMenuItem(
  //             child: const Text("audio"),
  //             onTap: () {
  //               playVerse(v);
  //             },
  //           ),
  //           PopupMenuItem(
  //             child: const Text("verse info"),
  //             onTap: () {
  //               _showVerseSheet(v);
  //             },
  //           ),
  //         ],
  //       );
  //     };

  //   _recognizers.add(recognizer);

  //   final isSelected = _selectedVerse != null &&
  //       _selectedVerse!.surahNumber == v.surahNumber &&
  //       _selectedVerse!.verseNumber == v.verseNumber;

  //   spans.add(
  //     TextSpan(
  //       text: txt,
  //       recognizer: recognizer,
  //       style: TextStyle(
  //         backgroundColor: isSelected
  //             ? Theme.of(context).colorScheme.secondary
  //             : Colors.transparent,
  //         color: Colors.black,
  //       ),
  //     ),
  //   );
  // }
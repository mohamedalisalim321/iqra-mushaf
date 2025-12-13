import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../database/surah_database.dart';
import '../../models/quran/verse.dart';
import '../../providers/page_font_size.dart';
import '../my_audio_player.dart';
import 'surah_header.dart';

class SurahQuran extends StatefulWidget {
  final PageController pageController;
  final ValueChanged<int>? onPageChanged;

  final bool showAudioPlayer;

  /// verse states
  final Verse? selectedVerse;
  final Verse? playingVerse;

  /// verse tap with position
  final void Function(Verse verse, Offset tapPosition)? onVerseTap;

  const SurahQuran({
    super.key,
    required this.pageController,
    required this.showAudioPlayer,
    this.onPageChanged,
    this.onVerseTap,
    this.selectedVerse,
    this.playingVerse,
  });

  @override
  State<SurahQuran> createState() => _SurahQuranState();
}

class _SurahQuranState extends State<SurahQuran> {
  final List<GestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: widget.pageController,
          itemCount: 604,
          onPageChanged: widget.onPageChanged,
          itemBuilder: (_, i) => FutureBuilder<Widget>(
            future: _buildPage(i + 1),
            builder: (_, s) {
              if (s.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (s.hasError) return _buildErrorPage(i + 1);
              return s.data ?? const SizedBox();
            },
          ),
        ),
        if (widget.showAudioPlayer)
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: MyAudioPlayer(),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorPage(int page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, size: 70, color: Colors.red[400]),
        const SizedBox(height: 10),
        Text(
          "تعذّر تحميل الصفحة $page",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
          label: const Text("إعادة المحاولة"),
        ),
      ],
    );
  }

  Future<Widget> _buildPage(int page) async {
    final ranges = SurahDatabase.getPageData(page);
    final font = "QCF_P${page.toString().padLeft(3, '0')}";
    final fontSize = getFontSize(page, context).sp;

    final spans = <InlineSpan>[];

    if (page <= 2) {
      spans.add(WidgetSpan(child: SizedBox(height: 110.h)));
    }

    for (final r in ranges) {
      await _addRange(spans, r, page, font);
    }

    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: spans,
        style: TextStyle(
          fontFamily: font,
          fontSize: fontSize,
          height: 2.h,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> _addRange(
    List<InlineSpan> spans,
    Map<String, int> range,
    int page,
    String font,
  ) async {
    final surah = range["surah"]!;
    final start = range["start"]!;
    final end = range["end"]!;

    for (int v = start; v <= end; v++) {
      if (v == 1 && v == start) {
        _addSurahHeader(spans, surah, page);
      }

      await _addVerse(
        spans,
        surah,
        v,
        font,
        isFirst: v == start,
      );
    }
  }

  void _addSurahHeader(List<InlineSpan> spans, int surah, int page) {
    spans.add(
      WidgetSpan(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: SurahHeader(suraNumber: surah),
        ),
      ),
    );

    if (page != 1 && page != 187) {
      spans.add(
        TextSpan(
          text: "齃𧻓𥳐龎\n",
          style: TextStyle(
            fontFamily: "QCF_BSML",
            fontSize:
                getScreenType(context) == ScreenType.large ? 13.2.sp : 18.sp,
          ),
        ),
      );
    }
  }

  Future<void> _addVerse(
    List<InlineSpan> spans,
    int surah,
    int verse,
    String font, {
    required bool isFirst,
  }) async {
    final v = await SurahDatabase.getVerseQcf(surah, verse);

    final txt =
        isFirst ? "${v.qcfData[0]}\u200A${v.qcfData.substring(1)}" : v.qcfData;

    final isSelected = _sameVerse(widget.selectedVerse, v);
    final isPlaying = _sameVerse(widget.playingVerse, v);

    final recognizer = TapGestureRecognizer()
      ..onTapDown = (d) {
        widget.onVerseTap?.call(v, d.globalPosition);
      };

    _recognizers.add(recognizer);

    spans.add(
      TextSpan(
        text: txt,
        recognizer: recognizer,
        style: TextStyle(
          backgroundColor: isPlaying
              ? Colors.amber.withOpacity(0.35) // 🔊 playing verse
              : isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.30) // 👆 selected verse
                  : Colors.transparent,
          color: Colors.black,
        ),
      ),
    );
  }

  bool _sameVerse(Verse? a, Verse b) {
    if (a == null) return false;
    return a.surahNumber == b.surahNumber && a.verseNumber == b.verseNumber;
  }
}


// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../database/surah_database.dart';
// import '../../models/quran/verse.dart';
// import '../../providers/page_font_size.dart';
// import '../my_audio_player.dart';
// import 'surah_header.dart';
// import 'verse_bottom_sheet.dart';

// class SurahQuran extends StatefulWidget {
//   final PageController pageController;
//   final ValueChanged<int>? onPageChanged;

//   final bool showAudioPlayer;
//   final ValueChanged<Verse>? onVerseTap;
//   final Verse? selectedVerse;

//   const SurahQuran({
//     super.key,
//     required this.pageController,
//     required this.showAudioPlayer,
//     required this.onPageChanged,
//     required this.onVerseTap,
//     required this.selectedVerse,
//   });

//   @override
//   State<SurahQuran> createState() => _SurahQuranState();
// }

// class _SurahQuranState extends State<SurahQuran> {
//   void _showVerseSheet(Verse verse) {
//     if (!mounted) return;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.black.withOpacity(0.2),
//       barrierColor: Colors.black54,
//       builder: (_) => VerseBottomSheet(verse: verse),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         if (widget.showAudioPlayer)
//           const Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: EdgeInsets.all(12),
//               child: MyAudioPlayer(),
//             ),
//           ),
//         PageView.builder(
//           controller: widget.pageController,
//           reverse: false,
//           itemCount: 604,
//           onPageChanged: widget.onPageChanged,
//           itemBuilder: (_, i) => FutureBuilder<Widget>(
//             future: _buildPage(i + 1),
//             builder: (_, s) {
//               if (s.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (s.hasError) return _buildErrorPage(i + 1);
//               return s.data ?? const SizedBox();
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorPage(int page) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.error, size: 70, color: Colors.red[400]),
//         const SizedBox(height: 10),
//         Text(
//           "تعذّر تحميل الصفحة $page",
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         TextButton.icon(
//           onPressed: () {},
//           icon: const Icon(Icons.refresh),
//           label: const Text("إعادة المحاولة"),
//         ),
//       ],
//     );
//   }

//   Future<Widget> _buildPage(int page) async {
//     final ranges = SurahDatabase.getPageData(page);
//     final font = "QCF_P${page.toString().padLeft(3, '0')}";
//     final fontSize = getFontSize(page, context).sp;

//     final spans = <InlineSpan>[];

//     if (page <= 2) {
//       spans.add(WidgetSpan(child: SizedBox(height: 110.h)));
//     }

//     for (final r in ranges) {
//       await _addRange(spans, r, page, font);
//     }

//     final widget = RichText(
//       textDirection: TextDirection.rtl,
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         children: spans,
//         style: TextStyle(
//           fontFamily: font,
//           fontSize: fontSize,
//           height: 2.h,
//           color: Colors.black,
//         ),
//       ),
//     );

//     return widget;
//   }

//   Future<void> _addRange(
//     List<InlineSpan> spans,
//     Map<String, int> range,
//     int page,
//     String font,
//   ) async {
//     final surah = range["surah"]!;
//     final start = range["start"]!;
//     final end = range["end"]!;

//     for (int v = start; v <= end; v++) {
//       if (v == 1 && v == start) {
//         _addSurahHeader(spans, surah, page);
//       }

//       await _addVerse(spans, surah, v, font, isFirst: v == start);
//     }
//   }

//   void _addSurahHeader(List<InlineSpan> spans, int surah, int page) {
//     spans.add(
//       WidgetSpan(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 12.h),
//           child: SurahHeader(suraNumber: surah),
//         ),
//       ),
//     );

//     if (page != 1 && page != 187) {
//       spans.add(
//         TextSpan(
//           text: "齃𧻓𥳐龎" + "\n",
//           style: TextStyle(
//             fontFamily: "QCF_BSML",
//             fontSize:
//                 getScreenType(context) == ScreenType.large ? 13.2.sp : 18.sp,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> _addVerse(
//     List<InlineSpan> spans,
//     int surah,
//     int verse,
//     String font, {
//     required bool isFirst,
//   }) async {
//     final v = await SurahDatabase.getVerseQcf(surah, verse);

//     final txt =
//         isFirst ? "${v.qcfData[0]}\u200A${v.qcfData.substring(1)}" : v.qcfData;

//     final recognizer = LongPressGestureRecognizer()
//       ..onLongPress = () => widget.onVerseTap!(v);

//     final isSelected = widget.selectedVerse != null &&
//         widget.selectedVerse!.surahNumber == v.surahNumber &&
//         widget.selectedVerse!.verseNumber == v.verseNumber;

//     spans.add(
//       TextSpan(
//         text: txt,
//         recognizer: recognizer,
//         style: TextStyle(
//           backgroundColor: isSelected
//               ? Theme.of(context).colorScheme.secondary
//               : Colors.transparent,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }

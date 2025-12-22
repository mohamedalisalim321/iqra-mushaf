import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../database/surah_database.dart';
import '../../models/quran/page_data.dart';
import '../../models/quran/range.dart';
import '../../models/quran/verse.dart';
import '../../providers/page_font_size.dart';
import 'quran_page_number.dart';
import 'surah_header.dart';

class QuranPage extends StatefulWidget {
  final int page;
  final Verse? selectedVerse;
  final Verse? playingVerse;
  final void Function(Verse verse)? onVerseTap;
  final List<GestureRecognizer> recognizers;

  const QuranPage({
    super.key,
    required this.page,
    required this.selectedVerse,
    required this.playingVerse,
    required this.onVerseTap,
    required this.recognizers,
  });

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late final Future<PageData> _pageFuture;

  /// Cache processed verse text (VERY important)
  final Map<String, String> _qcfCache = {};

  @override
  void initState() {
    super.initState();
    _pageFuture = _loadPage(widget.page);
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final r in widget.recognizers) {
      r.dispose();
    }
    widget.recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PageData>(
      future: _pageFuture,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final fontSize = getFontSize(widget.page, context).sp;

        _disposeRecognizers(); // 🔥 SAFE cleanup before rebuild

        final baseStyle = TextStyle(
          fontFamily: data.font,
          fontSize: fontSize,
          height: 2.1.h,
          color: Theme.of(context).colorScheme.onSurface,
        );

        return Column(
          children: [
            _buildHeader(data),
            Expanded(
              child: RepaintBoundary(
                child: RichText(
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: baseStyle,
                    children: _buildSpans(data),
                  ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        );
      },
    );
  }

  // ───────────────── HEADER ─────────────────

  Widget _buildHeader(PageData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Text(
        data.surahsNames.join('، '),
        style: TextStyle(
          fontSize: 12.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  // ───────────────── FOOTER ─────────────────

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment:
            widget.page.isOdd ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          QuranPageNumber(pageNumber: widget.page),
        ],
      ),
    );
  }

  // ───────────────── SPANS ─────────────────

  List<InlineSpan> _buildSpans(PageData data) {
    final spans = <InlineSpan>[];

    if (widget.page <= 2) {
      spans.add(WidgetSpan(child: SizedBox(height: 110.h)));
    }

    for (final r in data.ranges) {
      for (int v = r.start; v <= r.end; v++) {
        if (v == r.start && v == 1) {
          _addSurahHeader(spans, r.surah);
        }

        _addVerse(
          spans,
          r.surah,
          v,
          data.verses['${r.surah}:$v']!,
          isFirst: v == r.start,
        );
      }
    }

    return spans;
  }

  void _addSurahHeader(List<InlineSpan> spans, int surah) {
    spans.add(
      WidgetSpan(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: SurahHeader(suraNumber: surah),
        ),
      ),
    );

    if (widget.page != 1 && widget.page != 187) {
      spans.add(
        TextSpan(
          text: surah == 2 ? " ﱁ  ﱂﱃﱄ\n" : "齃𧻓𥳐龎\n",
          style: TextStyle(
            fontFamily: surah == 2 ? "QCF_P001" : "QCF_BSML",
            fontSize:
                getScreenType(context) == ScreenType.large ? 13.2.sp : 18.sp,
          ),
        ),
      );
    }
  }

  void _addVerse(
    List<InlineSpan> spans,
    int surah,
    int verse,
    Verse v, {
    required bool isFirst,
  }) {
    final key = '${v.surahNumber}:${v.verseNumber}';

    final cleaned = _qcfCache.putIfAbsent(
      key,
      () => v.qcfData.replaceAll(' ', ''),
    );

    final text =
        isFirst ? '${cleaned[0]}\u200A${cleaned.substring(1)}' : cleaned;

    final isPlaying = _sameVerse(widget.playingVerse, v);
    final isSelected = _sameVerse(widget.selectedVerse, v);

    final recognizer = LongPressGestureRecognizer()
      ..onLongPress = () => widget.onVerseTap?.call(v);

    widget.recognizers.add(recognizer);

    spans.add(
      TextSpan(
        text: text,
        recognizer: recognizer,
        style: TextStyle(
          backgroundColor: isPlaying
              ? Colors.amber.withOpacity(0.35)
              : isSelected
                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.30)
                  : Colors.transparent,
        ),
      ),
    );
  }

  bool _sameVerse(Verse? a, Verse b) =>
      a != null &&
      a.surahNumber == b.surahNumber &&
      a.verseNumber == b.verseNumber;

  // ───────────────── DATA ─────────────────

  Future<PageData> _loadPage(int page) async {
    final rangesRaw = SurahDatabase.getPageData(page);
    final font = "QCF_P${page.toString().padLeft(3, '0')}";

    final ranges = <Range>[];
    final verses = <String, Verse>{};

    for (final r in rangesRaw) {
      ranges.add(Range(r["surah"]!, r["start"]!, r["end"]!));
      for (int v = r["start"]!; v <= r["end"]!; v++) {
        final verse = await SurahDatabase.getVerseQcf(r["surah"]!, v);
        verses["${r["surah"]}:$v"] = verse;
      }
    }

    final surahsNames = await Future.wait(
      ranges.map((ran) async {
        final s = await SurahDatabase.getSurah(ran.surah);
        return s?.surahName ?? '';
      }),
    );

    return PageData(ranges, verses, font, surahsNames);
  }
}

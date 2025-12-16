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
  final void Function(Verse verse, Offset tapPosition)? onVerseTap;
  final void Function()? onQuranPageNumber;

  final List<GestureRecognizer> recognizers;

  const QuranPage({
    super.key,
    required this.page,
    required this.selectedVerse,
    required this.playingVerse,
    required this.onVerseTap,
    required this.onQuranPageNumber,
    required this.recognizers,
  });

  @override
  State<QuranPage> createState() => QuranPageState();
}

class QuranPageState extends State<QuranPage> {
  late final Future<PageData> _pageFuture;

  @override
  void initState() {
    super.initState();
    _pageFuture = _loadPage(widget.page);
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

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("الجزء الاول"),
                Text(data.surahsNames.join(",")),
              ],
            ),

            // 🧱 Prevent repaint of entire page
            RepaintBoundary(
              child: RichText(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: _buildSpans(data),
                  style: TextStyle(
                    fontFamily: data.font,
                    fontSize: fontSize,
                    height: 2.h,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            Spacer(),

            Row(
              mainAxisAlignment: widget.page.isEven
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                QuranPageNumber(
                  pageNumber: widget.page,
                  onTap: widget.onQuranPageNumber,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  List<InlineSpan> _buildSpans(PageData data) {
    final spans = <InlineSpan>[];

    if (widget.page <= 2) {
      spans.add(WidgetSpan(child: SizedBox(height: 110.h)));
    }

    for (final r in data.ranges) {
      for (int v = r.start; v <= r.end; v++) {
        if (v == 1 && v == r.start) {
          _addSurahHeader(spans, r.surah);
        }
        _addVerse(
          spans,
          r.surah,
          v,
          data.verses["${r.surah}:$v"]!,
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
  }

  void _addVerse(
    List<InlineSpan> spans,
    int surah,
    int verse,
    Verse v, {
    required bool isFirst,
  }) {
    final txt =
        isFirst ? "${v.qcfData[0]}\u200A${v.qcfData.substring(1)}" : v.qcfData;
    final isSelected = _sameVerse(widget.selectedVerse, v);
    final isPlaying = _sameVerse(widget.playingVerse, v);

    final recognizer = TapGestureRecognizer()
      ..onTapDown = (d) {
        widget.onVerseTap?.call(v, d.globalPosition);
      };

    widget.recognizers.add(recognizer);

    spans.add(
      TextSpan(
        text: txt,
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

  bool _sameVerse(Verse? a, Verse b) {
    if (a == null) return false;
    return a.surahNumber == b.surahNumber && a.verseNumber == b.verseNumber;
  }
}

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

  List<Future<String>> surahsNameFutures = ranges.map((ran) async {
    final surah = await SurahDatabase.getSurah(ran.surah);
    return surah?.surahName ?? '';
  }).toList();

  // Wait for all the Future<String> to complete
  final surahsName = await Future.wait(surahsNameFutures);

  return PageData(
    ranges,
    verses,
    font,
    surahsName,
  );
}

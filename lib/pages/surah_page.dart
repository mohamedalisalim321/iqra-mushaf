import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/quran/surah_header.dart';
import '../database/surah_database.dart';
import '../providers/page_font_size.dart';
import '../providers/quran.dart';

class SurahPage extends StatefulWidget {
  final int surahIndex;

  const SurahPage({super.key, required this.surahIndex});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  late final PageController pageController;
  int currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.surahIndex.clamp(1, totalPagesCount);
    pageController = PageController(initialPage: currentPageIndex - 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: pageController,
        reverse: true,
        itemCount: totalPagesCount,
        onPageChanged: (page) {
          setState(() => currentPageIndex = page + 1);
        },
        itemBuilder: (context, index) {
          final pageNumber = index + 1;

          return FutureBuilder<Widget>(
            future: _buildPage(pageNumber, context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return snapshot.data!;
            },
          );
        },
      ),
    );
  }

  /// Builds a single QCF page asynchronously
  Future<Widget> _buildPage(int pageNumber, BuildContext context) async {
    final ranges = getPageData(pageNumber);
    final pageFont = "QCF_P${pageNumber.toString().padLeft(3, '0')}";
    final fontSize = getFontSize(pageNumber, context).sp;

    final List<InlineSpan> verseSpans = [];

    // Add top spacing for pages 1 and 2
    if (pageNumber == 1 || pageNumber == 2) {
      verseSpans.add(
        WidgetSpan(
          child: SizedBox(height: MediaQuery.of(context).size.height * .175),
        ),
      );
    }

    for (final r in ranges) {
      final surah = r['surah'];
      final start = r['start'];
      final end = r['end'];

      for (int v = start; v <= end; v++) {
        // Surah header + Basmallah
        if (v == start && v == 1) {
          verseSpans.add(WidgetSpan(child: SurahHeader(suraNumber: surah)));

          if (pageNumber != 1 && pageNumber != 187) {
            verseSpans.add(
              TextSpan(
                text: surah == 97 ? "齃𧻓𥳐龎\n" : " ﱁ  ﱂﱃﱄ\n",
                style: TextStyle(
                  fontFamily: surah == 97 ? "QCF_BSML" : "QCF_P001",
                  fontSize: (getScreenType(context) == ScreenType.large
                      ? 13.2.sp
                      : surah == 97
                          ? 18.sp
                          : 24.sp),
                  color: Colors.black,
                ),
              ),
            );
          }
        }

        // Load verse text
        final rawVerse = await SurahDatabase.getVerseQcf(
          surah,
          v,
          verseEndSymbol: false,
        );

        final formattedVerse = (v == ranges[0]['start'])
            ? "${rawVerse.substring(0, 1)}\u200A${rawVerse.substring(1)}"
            : rawVerse;

        // Add verse and its number
        verseSpans.add(
          TextSpan(
            text: formattedVerse,
            children: [
              TextSpan(
                text: SurahDatabase.getVerseNumberQcf(v),
                style: TextStyle(
                  fontFamily: pageFont,
                  height: 1.35.h,
                  color: Colors.black,
                ),
              )
            ],
          ),
        );
      }
    }

    return RichText(
      locale: const Locale("ar"),
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: verseSpans,
        style: TextStyle(
          fontFamily: pageFont,
          color: Colors.black,
          fontSize: fontSize,
          height: 2.2.h,
        ),
      ),
    );
  }
}

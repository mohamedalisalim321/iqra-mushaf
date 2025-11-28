import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iqra/database/verse_data_database.dart';

import '../components/quran/surah_header.dart';
import '../database/surah_database.dart';
import '../models/quran/verse.dart';
import '../providers/page_font_size.dart';

class SurahPage extends StatefulWidget {
  final int surahIndex;

  const SurahPage({super.key, required this.surahIndex});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  List<GlobalKey> richTextKeys = List.generate(604, (_) => GlobalKey());
  Verse? selectedVerse;
  int selectedWordIndex = 1;
  late final PageController pageController;
  int currentPageIndex = 1;

  final List<LongPressGestureRecognizer> _recognizers = [];

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.surahIndex.clamp(1, 604);
    pageController = PageController(initialPage: currentPageIndex - 1);
  }

  @override
  void dispose() {
    for (var r in _recognizers) {
      r.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  void showVerseSheet(Verse verse, String pageFont, double fontSize) {
    final words = verse.verseText.split(" ");

    // Create a list of recognizers for this sheet (to dispose later if needed)
    final List<LongPressGestureRecognizer> wordRecognizers = [];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: words.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String word = entry.value;

                      final recognizer = LongPressGestureRecognizer()
                        ..onLongPress = () {
                          setState(() {
                            selectedWordIndex = index;
                          });
                        };
                      wordRecognizers.add(recognizer);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedWordIndex = index;
                          });
                        },
                        child: Text(
                          word,
                          style: TextStyle(
                            color: Colors.black,
                            backgroundColor: selectedWordIndex == index
                                ? Colors.red
                                : Colors.transparent,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Wrap(
                //   textDirection: TextDirection.rtl,
                //   spacing: 8,
                //   runSpacing: 8,
                //   children: ,
                // ),
                FutureBuilder(
                  future: VerseDataDatabase.getVerseData(
                    verse.surahNumber,
                    verse.verseNumber,
                    selectedWordIndex + 1,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final verseData = snapshot.data!;

                    return Column(
                      children: [
                        // Text(verseData.irab),
                        Text(verseData.sarf),
                        // Text(verseData.wordMeaning),
                      ],
                    );
                  },
                )
              ],
            );
            //
          },
        );
      },
    ).then((_) {
      // Optional: dispose recognizers when sheet is closed
      for (var r in wordRecognizers) {
        r.dispose();
      }
    });

    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     return ListView(
    //       children: [
    //         RichText(
    //           text: TextSpan(
    //             style: TextStyle(
    //               fontFamily: pageFont,
    //               color: Colors.black,
    //               fontSize: fontSize,
    //               height: 2.h,
    //             ),
    //             children: verse.normalVerse.split(" ").expand((word) {
    //               List<InlineSpan> spans = [];
    //               int wordNumber = verse.verseText.split(" ").indexOf(word);

    //               spans.add(
    //                 TextSpan(
    //                   text: verse.normalVerse + " ",
    //                   style: TextStyle(
    //                     backgroundColor: (selectedWord == wordNumber)
    //                         ? Colors.red
    //                         : Colors.blue,
    //                   ),
    //                   recognizer: LongPressGestureRecognizer()
    //                     ..onLongPress = () {
    //                       setState(() {
    //                         selectedWord = wordNumber;
    //                       });
    //                     },
    //                 ),
    //               );

    //               return spans;
    //             }).toList(),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );

    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) {

    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        reverse: true,
        itemCount: 604,
        onPageChanged: (page) {
          setState(() {
            currentPageIndex = page + 1;
            selectedVerse = null;
          });
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
    final ranges = SurahDatabase.getPageData(pageNumber);
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
          verseSpans.add(
            WidgetSpan(
              child: SurahHeader(suraNumber: surah),
            ),
          );

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
        final verse = await SurahDatabase.getVerseQcf(
          surah,
          v,
          verseEndSymbol: false,
        );

        final formattedVerse = (v == ranges[0]["start"])
            ? "${verse.qcfData.substring(0, 1)}\u200A${verse.qcfData.substring(1)}"
            : verse.qcfData;

        // Create recognizer
        final recognizer = LongPressGestureRecognizer()
          ..onLongPress = () {
            setState(() {
              selectedVerse = verse;
            });
            showVerseSheet(verse, pageFont, fontSize);
          };
        _recognizers.add(recognizer);

        // Add verse and its number
        verseSpans.add(
          TextSpan(
            text: formattedVerse,
            recognizer: recognizer,
            style: TextStyle(
              backgroundColor: (selectedVerse != null)
                  ? (selectedVerse!.verseNumber == verse.verseNumber)
                      ? Colors.blue
                      : Colors.transparent
                  : Colors.transparent,
            ),
          ),
        );
      }
    }

    return SingleChildScrollView(
      child: RichText(
        key: richTextKeys[pageNumber - 1],
        locale: const Locale("ar"),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: verseSpans,
          style: TextStyle(
            fontFamily: pageFont,
            color: Colors.black,
            fontSize: fontSize,
            height: 2.h,
          ),
        ),
      ),
    );
  }
}

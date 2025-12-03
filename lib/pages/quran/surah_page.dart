import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/quran/surah_header.dart';
import '../../database/surah_database.dart';
import '../../database/verse_data_database.dart';
import '../../models/quran/surah.dart';
import '../../models/quran/verse.dart';
import '../../providers/page_font_size.dart';

class SurahPage extends StatefulWidget {
  final int surahIndex;
  const SurahPage({super.key, required this.surahIndex});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage>
    with SingleTickerProviderStateMixin {
  List<Surah> surahs = [];

  final List<LongPressGestureRecognizer> _recognizers = [];
  late final PageController pageController;
  late final TabController tabsController;

  Verse? selectedVerse;
  int selectedWordIndex = 0;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    currentPage = widget.surahIndex.clamp(1, 604);
    pageController = PageController(initialPage: currentPage - 1);
    tabsController = TabController(length: 3, vsync: this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    loadSurahs();
  }

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> loadSurahs() async {
    try {
      final list = await SurahDatabase.getAllSurahs();
      setState(() {
        surahs = list;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void navigateToSurah(int surahIndex) {
    int surahPageNum = SurahDatabase.getPageNumber(surahIndex, 1) - 1;

    setState(() {
      currentPage = surahPageNum;
      pageController.jumpToPage(
        surahPageNum,
      );
    });
  }

  void showVerseSheet(Verse verse, String fontFamily) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: RichText(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          children: verse.qcfData
                              .split("")
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final word = entry.value.replaceAll("\n", "");

                            if (index ==
                                verse.qcfData.split("").asMap().entries.length -
                                    1) {
                              return TextSpan(
                                text: "$word ",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  backgroundColor: (selectedWordIndex == index)
                                      ? Colors.red
                                      : Colors.transparent,
                                ),
                              );
                            }

                            return TextSpan(
                              text: "$word ",
                              style: TextStyle(
                                fontFamily: fontFamily,
                                color: (selectedWordIndex == index)
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              recognizer: LongPressGestureRecognizer()
                                ..onLongPress = () {
                                  setState(() {
                                    selectedWordIndex = index;
                                  });
                                },
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Word Data Loader ---
                    FutureBuilder(
                      future: VerseDataDatabase.getVerseData(
                        verse.surahNumber,
                        verse.verseNumber,
                        selectedWordIndex + 1,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          );
                        }

                        final data = snapshot.data!;

                        return DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              TabBar(
                                controller: tabsController,
                                labelColor: Colors.blue,
                                tabs: const [
                                  Tab(text: "الصرف"),
                                  Tab(text: "اﻷعراب"),
                                  Tab(text: "المعني"),
                                ],
                              ),
                              SizedBox(
                                height: 200,
                                child: TabBarView(
                                  controller: tabsController,
                                  children: [
                                    Text(data.sarf),
                                    Text(data.irab),
                                    Text(data.wordMeaning),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: surahs.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: surahs.length,
                itemBuilder: (context, index) {
                  final surah = surahs[index];
                  return ListTile(
                    onTap: () => navigateToSurah(surah.surahIndex),
                    title: CircleAvatar(
                      radius: 24,
                      child: Text(
                        surah.surahIndex.toString(),
                        style: TextStyle(
                          // fontFamily: "Lateef",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    trailing: Text(
                      surah.surahName,
                    ),
                  );
                },
              ),
      ),
      body: PageView.builder(
        controller: pageController,
        reverse: true,
        itemCount: 604,
        onPageChanged: (page) {
          setState(() {
            currentPage = page + 1;
            selectedVerse = null;
          });
        },
        itemBuilder: (context, index) {
          final pageNumber = index + 1;

          return FutureBuilder(
            future: _buildPage(pageNumber),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return snap.data!;
            },
          );
        },
      ),
    );
  }

  // =============================
  //  BUILD QURAN PAGE
  // =============================
  Future<Widget> _buildPage(int pageNumber) async {
    final ranges = SurahDatabase.getPageData(pageNumber);
    final pageFont = "QCF_P${pageNumber.toString().padLeft(3, '0')}";
    final fontSize = getFontSize(pageNumber, context).sp;

    final spans = <InlineSpan>[];

    // Top spacing (same as mushaf)
    if (pageNumber == 1 || pageNumber == 2) {
      spans.add(const WidgetSpan(child: SizedBox(height: 120)));
    }

    for (final r in ranges) {
      final surah = r["surah"];
      final start = r["start"];
      final end = r["end"];

      for (int v = start; v <= end; v++) {
        // ===== SURAH HEADER + BASMALLAH =====
        if (v == start && v == 1) {
          spans.add(WidgetSpan(child: SurahHeader(suraNumber: surah)));

          if (pageNumber != 1 && pageNumber != 187) {
            spans.add(
              TextSpan(
                text: (surah == 97 ? "齃𧻓𥳐龎" : " ﱁ  ﱂﱃﱄ") + "\n",
                style: TextStyle(
                  fontFamily: surah == 97 ? "QCF_BSML" : "QCF_P001",
                  fontSize: 22.sp,
                ),
              ),
            );
          }
        }

        // ===== VERSE TEXT =====
        final verse =
            await SurahDatabase.getVerseQcf(surah, v, verseEndSymbol: false);

        // Special formatting for the first verse on a page
        final qcf = (v == ranges.first["start"])
            ? "${verse.qcfData[0]}\u200A${verse.qcfData.substring(1)}"
            : verse.qcfData;

        // Build recognizer
        final recognizer = LongPressGestureRecognizer()
          ..onLongPress = () {
            setState(() => selectedVerse = verse);
            showVerseSheet(verse, pageFont);
          };
        _recognizers.add(recognizer);

        spans.add(
          TextSpan(
            text: qcf,
            recognizer: recognizer,
            style: TextStyle(
              backgroundColor: (selectedVerse != null &&
                      selectedVerse!.verseNumber == verse.verseNumber)
                  ? Colors.blue.withOpacity(.25)
                  : Colors.transparent,
            ),
          ),
        );
      }
    }

    return SingleChildScrollView(
      child: RichText(
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: spans,
          style: TextStyle(
            fontFamily: pageFont,
            fontSize: fontSize,
            color: Colors.black,
            height: 2,
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../components/quran/surah_header.dart';
// import '../../database/surah_database.dart';
// import '../../database/verse_data_database.dart';
// import '../../models/quran/verse.dart';
// import '../../providers/page_font_size.dart';

// class SurahPage extends StatefulWidget {
//   final int surahIndex;

//   const SurahPage({super.key, required this.surahIndex});

//   @override
//   State<SurahPage> createState() => _SurahPageState();
// }

// class _SurahPageState extends State<SurahPage> {
//   List<GlobalKey> richTextKeys = List.generate(604, (_) => GlobalKey());
//   Verse? selectedVerse;
//   int selectedWordIndex = 1;
//   late final PageController pageController;
//   int currentPageIndex = 1;

//   final List<LongPressGestureRecognizer> _recognizers = [];

//   @override
//   void initState() {
//     super.initState();
//     currentPageIndex = widget.surahIndex.clamp(1, 604);
//     pageController = PageController(initialPage: currentPageIndex - 1);
//   }

//   @override
//   void dispose() {
//     for (var r in _recognizers) {
//       r.dispose();
//     }
//     pageController.dispose();
//     super.dispose();
//   }

//   void showVerseSheet(Verse verse, String pageFont, double fontSize) {
//     final words = verse.verseText.split(" ");
//     final List<LongPressGestureRecognizer> wordRecognizers = [];

//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Column(
//               children: [
//                 SingleChildScrollView(
//                   padding: EdgeInsets.all(8),
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     textDirection: TextDirection.rtl,
//                     children: words.asMap().entries.map((entry) {
//                       final int index = entry.key;
//                       final String word = entry.value;

//                       final recognizer = LongPressGestureRecognizer()
//                         ..onLongPress = () {
//                           setState(() {
//                             selectedWordIndex = index;
//                           });
//                         };
//                       wordRecognizers.add(recognizer);

//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedWordIndex = index;
//                           });
//                         },
//                         child: Text(
//                           word,
//                           style: TextStyle(
//                             color: Colors.black,
//                             backgroundColor: selectedWordIndex == index
//                                 ? Colors.red
//                                 : Colors.transparent,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 FutureBuilder(
//                   future: VerseDataDatabase.getVerseData(
//                     verse.surahNumber,
//                     verse.verseNumber,
//                     selectedWordIndex + 1,
//                   ),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }

//                     final verseData = snapshot.data!;

//                     return Column(
//                       children: [
//                         // Text(verseData.irab),
//                         Text(verseData.sarf),
//                         // Text(verseData.wordMeaning),
//                       ],
//                     );
//                   },
//                 )
//               ],
//             );
//           },
//         );
//       },
//     ).then((_) {
//       for (var r in wordRecognizers) {
//         r.dispose();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         controller: pageController,
//         reverse: true,
//         itemCount: 604,
//         onPageChanged: (page) {
//           setState(() {
//             currentPageIndex = page + 1;
//             selectedVerse = null;
//           });
//         },
//         itemBuilder: (context, index) {
//           final pageNumber = index + 1;

//           return FutureBuilder<Widget>(
//             future: _buildPage(pageNumber, context),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               return snapshot.data!;
//             },
//           );
//         },
//       ),
//     );
//   }

//   /// Builds a single QCF page asynchronously
//   Future<Widget> _buildPage(int pageNumber, BuildContext context) async {
//     final ranges = SurahDatabase.getPageData(pageNumber);
//     final pageFont = "QCF_P${pageNumber.toString().padLeft(3, '0')}";
//     final fontSize = getFontSize(pageNumber, context).sp;

//     final List<InlineSpan> verseSpans = [];

//     // Add top spacing for pages 1 and 2
//     if (pageNumber == 1 || pageNumber == 2) {
//       verseSpans.add(
//         WidgetSpan(
//           child: SizedBox(height: MediaQuery.of(context).size.height * .175),
//         ),
//       );
//     }

//     for (final r in ranges) {
//       final surah = r['surah'];
//       final start = r['start'];
//       final end = r['end'];

//       for (int v = start; v <= end; v++) {
//         // Surah header + Basmallah
//         if (v == start && v == 1) {
//           verseSpans.add(
//             WidgetSpan(
//               child: SurahHeader(suraNumber: surah),
//             ),
//           );

//           if (pageNumber != 1 && pageNumber != 187) {
//             verseSpans.add(
//               TextSpan(
//                 text: surah == 97 ? "齃𧻓𥳐龎\n" : " ﱁ  ﱂﱃﱄ\n",
//                 style: TextStyle(
//                   fontFamily: surah == 97 ? "QCF_BSML" : "QCF_P001",
//                   fontSize: (getScreenType(context) == ScreenType.large)
//                       ? 13.2.sp
//                       : surah == 97
//                           ? 18.sp
//                           : 24.sp,
//                   color: Colors.black,
//                 ),
//               ),
//             );
//           }
//         }

//         // Load verse text
//         final verse =
//             await SurahDatabase.getVerseQcf(surah, v, verseEndSymbol: false);

//         final formattedVerse = (v == ranges[0]["start"])
//             ? "${verse.qcfData.substring(0, 1)}\u200A${verse.qcfData.substring(1)}"
//             : verse.qcfData;

//         // Create recognizer
//         final recognizer = LongPressGestureRecognizer()
//           ..onLongPress = () {
//             setState(() {
//               selectedVerse = verse;
//             });
//             showVerseSheet(verse, pageFont, fontSize);
//           };
//         _recognizers.add(recognizer);

//         verseSpans.add(
//           TextSpan(
//             text: formattedVerse,
//             recognizer: recognizer,
//             style: TextStyle(
//               backgroundColor: (selectedVerse != null)
//                   ? (selectedVerse!.verseNumber == verse.verseNumber)
//                       ? Colors.blue
//                       : Colors.transparent
//                   : Colors.transparent,
//             ),
//           ),
//         );
//       }
//     }

//     return SingleChildScrollView(
//       child: RichText(
//         key: richTextKeys[pageNumber - 1],
//         locale: const Locale("ar"),
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.rtl,
//         text: TextSpan(
//           children: verseSpans,
//           style: TextStyle(
//             fontFamily: pageFont,
//             color: Colors.black,
//             fontSize: fontSize,
//             height: 2.h,
//           ),
//         ),
//       ),
//     );
//   }
// }

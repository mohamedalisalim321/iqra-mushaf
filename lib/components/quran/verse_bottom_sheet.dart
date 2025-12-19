import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../database/verse_data_database.dart';
import '../../models/quran/verse.dart';
import '../../models/quran/verse_data.dart';
import '../../providers/app_settings.dart';
import '../../services/audio_service.dart';
import '../../utils/utils.dart';

// flutter pub run build_runner build

class VerseBottomSheet extends StatefulWidget {
  final Verse verse;

  const VerseBottomSheet({super.key, required this.verse});

  @override
  State<VerseBottomSheet> createState() => _VerseBottomSheetState();
}

class _VerseBottomSheetState extends State<VerseBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _charScroll;

  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  List<VerseData>? _verseData;
  late final List<String> _characters;

  bool _loading = true;

  AudioService get _audio => AudioService.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _charScroll = ScrollController();

    _characters = _parseCharacters();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _charScroll.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }

  // ──────────────────────────────
  // DATA
  // ──────────────────────────────

  Future<void> _loadData() async {
    final data = await VerseDataDatabase.getVerseWords(
      widget.verse.surahNumber,
      widget.verse.verseNumber,
    );

    if (!mounted) return;

    setState(() {
      _verseData = data;
      _loading = false;
    });
  }

  List<String> _parseCharacters() {
    final text =
        "${widget.verse.verseText} ${widget.verse.verseNumber.toArabicDigits()}";
    return text.split(" ").where((e) => e.trim().isNotEmpty).toList();
  }

  void _selectChar(int index) {
    _selectedIndex.value = index;

    /// 🔥 auto-center selected word
    _charScroll.animateTo(
      index * 42.w,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // ──────────────────────────────
  // UI
  // ──────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: .75,
        minChildSize: .55,
        maxChildSize: .97,
        expand: false,
        builder: (_, __) {
          return Column(
            children: [
              _handle(scheme),
              _verseHeader(scheme),
              _characterSelector(scheme),
              Expanded(child: _content(scheme)),
              _audioControls(scheme),
            ],
          );
        },
      ),
    );
  }

  Widget _handle(ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Container(
        width: 45.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(.25),
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _verseHeader(ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "سورة ${widget.verse.surahName}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
              ),
              Text(
                "آية ${widget.verse.verseNumber.toArabicDigits()}",
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
          Text(
            _audio.currentReciter.value?.name ?? "",
            style: TextStyle(
              fontSize: 12.sp,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _characterSelector(ColorScheme scheme) {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        controller: _charScroll,
        scrollDirection: Axis.horizontal,
        itemCount: _characters.length,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemBuilder: (_, i) {
          return ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (_, sel, __) {
              final selected = sel == i;
              return GestureDetector(
                onTap: () => _selectChar(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: selected
                        ? scheme.primary.withOpacity(.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _characters[i],
                    style: TextStyle(
                      fontFamily: "Hafs",
                      fontSize: 24.sp,
                      color: selected ? scheme.primary : scheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _content(ColorScheme scheme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_verseData == null || _verseData!.isEmpty) {
      return Center(
        child: Text(
          "لا توجد بيانات لغوية",
          style: TextStyle(fontSize: 15.sp),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.secondary),
              borderRadius: BorderRadius.circular(12.r),
              color: scheme.surface,
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: scheme.primary,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: scheme.onSurface.withOpacity(.6),
              tabs: const [
                Tab(text: "الصرف"),
                Tab(text: "الإعراب"),
                Tab(text: "المعنى"),
              ],
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (_, i, __) {
              final data = _verseData![i.clamp(0, _verseData!.length - 1)];
              return TabBarView(
                controller: _tabController,
                children: [
                  _dataCard(data.sarf, scheme),
                  _dataCard(data.irab, scheme),
                  _dataCard(data.wordMeaning, scheme),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _dataCard(String text, ColorScheme scheme) {
    final settings = context.read<AppSettings>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.primary.withOpacity(.2)),
        ),
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          text: TextSpan(
            children: parseArabicText(text.replaceAll("،", ",")),
            style: TextStyle(
              fontFamily: settings.currentFont,
              fontSize: settings.arabicFontSize,
              height: 1.6,
              color: scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────
  // AUDIO CONTROLS
  // ──────────────────────────────
  Widget _audioControls(ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          IconButton(
            iconSize: 56,
            icon: Icon(
              Icons.play_circle,
              color: scheme.primary,
            ),
            onPressed: () {
              Navigator.pop(context);
              _audio.playVerse(widget.verse);
            },
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../database/verse_data_database.dart';
// import '../../models/quran/verse.dart';
// import '../../models/quran/verse_data.dart';
// import '../../services/audio_service.dart';
// import '../../utils/utils.dart';

// class VerseBottomSheet extends StatefulWidget {
//   final Verse verse;

//   const VerseBottomSheet({
//     super.key,
//     required this.verse,
//   });

//   @override
//   State<VerseBottomSheet> createState() => _VerseBottomSheetState();
// }

// class _VerseBottomSheetState extends State<VerseBottomSheet>
//     with SingleTickerProviderStateMixin {
//   late final TabController _tabController;

//   final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

//   List<VerseData>? _verseData;
//   late final List<String> _characters;

//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _characters = _parseCharacters();
//     _loadData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _selectedIndex.dispose();
//     super.dispose();
//   }

//   // ──────────────────────────────
//   // DATA
//   // ──────────────────────────────

//   Future<void> _loadData() async {
//     final data = await VerseDataDatabase.getVerseWords(
//       widget.verse.surahNumber,
//       widget.verse.verseNumber,
//     );

//     if (!mounted) return;

//     setState(() {
//       _verseData = data;
//       _loading = false;
//     });
//   }

//   List<String> _parseCharacters() {
//     final text =
//         "${widget.verse.verseText} ${widget.verse.verseNumber.toArabicDigits()}";
//     return text.split(" ").where((e) => e.trim().isNotEmpty).toList();
//   }

//   void _selectChar(int i) {
//     _selectedIndex.value = i;
//   }

//   // ──────────────────────────────
//   // UI
//   // ──────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
//       ),
//       child: DraggableScrollableSheet(
//         initialChildSize: 0.74,
//         minChildSize: 0.5,
//         maxChildSize: 0.97,
//         expand: false,
//         builder: (_, __) {
//           return Column(
//             children: [
//               _verseHeader(scheme),
//               _characterSelector(scheme),
//               Expanded(child: _content(scheme)),
//               Container(
//                 padding: EdgeInsets.all(18.w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(18),
//                   border: Border.all(color: scheme.primary.withOpacity(.2)),
//                 ),
//                 child: IconButton(
//                   icon: const Icon(Icons.play_arrow_rounded),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     AudioService.instance.playVerse(widget.verse);
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _verseHeader(ColorScheme scheme) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Column(
//             children: [
//               Text(
//                 "سورة ${widget.verse.surahName}",
//                 style: TextStyle(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 textDirection: TextDirection.rtl,
//               ),
//               Text(
//                 "آية ${widget.verse.verseNumber.toArabicDigits()}",
//                 style: TextStyle(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           Text(AudioService.instance.currentReciter.value!.name),
//         ],
//       ),
//     );
//   }

//   Widget _characterSelector(ColorScheme scheme) {
//     return Container(
//       height: 50.h,
//       margin: EdgeInsets.all(8.w),
//       decoration: BoxDecoration(
//         color: scheme.surface,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _characters.length,
//         padding: EdgeInsets.symmetric(horizontal: 8.w),
//         itemBuilder: (_, i) {
//           return ValueListenableBuilder<int>(
//             valueListenable: _selectedIndex,
//             builder: (_, sel, __) {
//               final selected = sel == i;
//               return GestureDetector(
//                 onTap: () => _selectChar(i),
//                 child: Padding(
//                   padding: const EdgeInsets.all(4),
//                   child: Text(
//                     _characters[i],
//                     style: TextStyle(
//                       fontFamily: "Hafs",
//                       fontSize: 20.sp,
//                       color: selected ? Colors.blue : Colors.black,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _content(ColorScheme scheme) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_verseData == null || _verseData!.isEmpty) {
//       return Center(
//         child: Text(
//           "لا توجد بيانات لغوية",
//           style: TextStyle(fontSize: 15.sp),
//         ),
//       );
//     }

//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 8.w),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: Theme.of(context).colorScheme.surface,
//           ),
//           child: TabBar(
//             controller: _tabController,
//             indicatorSize: TabBarIndicatorSize.tab,
//             dividerColor: Colors.transparent,
//             indicator: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.black54,
//             tabs: const [
//               Tab(text: "الصرف"),
//               Tab(text: "الإعراب"),
//               Tab(text: "المعنى"),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ValueListenableBuilder<int>(
//             valueListenable: _selectedIndex,
//             builder: (_, i, __) {
//               final data = _verseData![i.clamp(0, _verseData!.length - 1)];
//               return TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _dataCard(data.sarf, scheme),
//                   _dataCard(data.irab, scheme),
//                   _dataCard(data.wordMeaning, scheme),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _dataCard(String text, ColorScheme scheme) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.w),
//       child: Container(
//         padding: EdgeInsets.all(18.w),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: scheme.primary.withOpacity(.2)),
//         ),
//         child: RichText(
//           textDirection: TextDirection.rtl,
//           textAlign: TextAlign.right,
//           text: TextSpan(
//             children: parseArabicText(text.replaceAll("،", ",")),
//             style: TextStyle(
//               fontFamily: "Hafs",
//               fontSize: 24.sp,
//               height: 1.5,
//               color: scheme.onSurface,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

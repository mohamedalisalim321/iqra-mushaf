import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);
  late final List<String> _characters;

  late final Future<List<VerseData>> _dataFuture;

  AudioService get _audio => AudioService.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _characters = _parseCharacters();
    _dataFuture = _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }

  // ──────────────────────────────
  // DATA
  // ──────────────────────────────

  Future<List<VerseData>> _loadData() {
    return VerseDataDatabase.getVerseWords(
      widget.verse.surahNumber,
      widget.verse.verseNumber,
    );
  }

  List<String> _parseCharacters() {
    final text =
        "${widget.verse.verseText} ${widget.verse.verseNumber.toArabicDigits()}";
    return text.split(" ").where((e) => e.trim().isNotEmpty).toList();
  }

  void _selectChar(int index) {
    HapticFeedback.selectionClick();
    _selectedIndex.value = index;
  }

  // ──────────────────────────────
  // UI
  // ──────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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

  Widget _characterSelector(ColorScheme scheme) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (_, sel, __) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: _characters.length,
            itemBuilder: (_, i) {
              final selected = sel == i;
              return GestureDetector(
                onTap: () => _selectChar(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
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
                      fontSize: 22.sp,
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
    return FutureBuilder<List<VerseData>>(
      future: _dataFuture,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return Center(
            child:
                Text("لا توجد بيانات لغوية", style: TextStyle(fontSize: 15.sp)),
          );
        }

        return Column(
          children: [
            _tabBar(scheme),
            SizedBox(height: 10.h),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _selectedIndex,
                builder: (_, i, __) {
                  final safeIndex = i.clamp(0, snapshot.data!.length - 1);
                  final data = snapshot.data![safeIndex];

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
      },
    );
  }

  Widget _tabBar(ColorScheme scheme) {
    return Padding(
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
          labelStyle: TextStyle(
            fontFamily: "Kufi",
          ),
          labelColor: Colors.white,
          unselectedLabelColor: scheme.onSurface.withOpacity(.6),
          tabs: const [
            Tab(text: "التصريف"),
            Tab(text: "الإعراب"),
            Tab(text: "المعنى"),
          ],
        ),
      ),
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
          border: Border.all(color: scheme.surface),
          color: scheme.secondary.withOpacity(.2),
        ),
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          text: TextSpan(
            children: parseArabicText(context, text.replaceAll("،", ", ")),
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
  // AUDIO
  // ──────────────────────────────

  Widget _audioControls(ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.primary.withOpacity(.2)),
          color: scheme.secondary,
        ),
        child: IconButton(
          iconSize: 56,
          icon: Icon(Icons.play_circle_fill_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            _audio.playVerse(widget.verse);
          },
        ),
      ),
    );
  }
}

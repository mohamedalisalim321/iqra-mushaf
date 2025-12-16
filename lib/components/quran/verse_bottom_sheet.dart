import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../database/verse_data_database.dart';
import '../../models/quran/verse.dart';
import '../../models/quran/verse_data.dart';
import '../../utils/utils.dart';

class VerseBottomSheet extends StatefulWidget {
  final Verse verse;

  const VerseBottomSheet({
    super.key,
    required this.verse,
  });

  @override
  State<VerseBottomSheet> createState() => VerseBottomSheetState();
}

class VerseBottomSheetState extends State<VerseBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<String> _characters;
  late final ScrollController _scrollController;

  List<VerseData>? _cachedVerseData;
  bool _loadingData = true;

  int _selectedCharIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _characters = _parseCharacters();

    _loadAndCacheVerseData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAndCacheVerseData() async {
    setState(() => _loadingData = true);

    final data = await VerseDataDatabase.getVerseWords(
      widget.verse.surahNumber,
      widget.verse.verseNumber,
    );

    if (!mounted) return;

    setState(() {
      _cachedVerseData = data;
      _loadingData = false;
    });
  }

  List<String> _parseCharacters() {
    final text =
        "${widget.verse.verseText} ${widget.verse.verseNumber.toArabicDigits()}";

    return text.split(" ").where((c) => c.trim().isNotEmpty).toList();
  }

  void _onCharacterSelected(int index) {
    if (index < 0 ||
        index >= _characters.length - 1 ||
        index == _selectedCharIndex) return;

    setState(() {
      _selectedCharIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.74,
        minChildSize: 0.5,
        maxChildSize: 0.97,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            _buildHandle(scheme),
            _buildCharacterSelector(scheme),
            Expanded(child: _buildWordDataSection(scheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Container(
        width: 45.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(0.25),
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildCharacterSelector(ColorScheme scheme) {
    return Container(
      height: 90.h,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _characters.length,
        itemExtent: null, // Let items size naturally but cache
        cacheExtent: 500, // Preload more items
        itemBuilder: (_, i) {
          return _CharacterItem(
            character: _characters[i],
            index: i,
            isSelected: _selectedCharIndex == i,
            onTap: _onCharacterSelected,
            scheme: scheme,
          );
        },
      ),
    );
  }

  //--------------------------------------
  // WORD DATA SECTION
  //--------------------------------------
  Widget _buildWordDataSection(ColorScheme scheme) {
    if (_loadingData) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: scheme.primary.withOpacity(0.2)),
            ),
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            labelColor: scheme.primary,
            unselectedLabelColor: scheme.onSurface.withOpacity(0.5),
            indicatorColor: scheme.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "الصرف"),
              Tab(text: "الإعراب"),
              Tab(text: "المعنى"),
            ],
          ),
        ),
        Expanded(child: _buildWordData(scheme)),
      ],
    );
  }

  //--------------------------------------
  // CACHED WORD-DATA READER
  //--------------------------------------
  Widget _buildWordData(ColorScheme scheme) {
    if (_cachedVerseData == null || _cachedVerseData!.isEmpty) {
      return _buildErrorState(scheme);
    }

    final safeIndex = _selectedCharIndex.clamp(0, _cachedVerseData!.length - 1);
    final data = _cachedVerseData![safeIndex];

    return TabBarView(
      controller: _tabController,
      children: [
        _DataCard(text: data.sarf, scheme: scheme),
        _DataCard(text: data.irab, scheme: scheme),
        _DataCard(text: data.wordMeaning, scheme: scheme),
      ],
    );
  }

  //--------------------------------------
  // ERROR
  //--------------------------------------
  Widget _buildErrorState(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline,
              size: 60.w, color: scheme.primary.withOpacity(0.4)),
          SizedBox(height: 16.w),
          Text(
            "لا توجد بيانات متاحة",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: scheme.onSurface.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 6.w),
          Text(
            "اختر حرفاً آخر لعرض التفاصيل",
            style: TextStyle(
              fontSize: 14.sp,
              color: scheme.onSurface.withOpacity(0.6),
            ),
          )
        ],
      ),
    );
  }
}

//--------------------------------------
// STATELESS CHARACTER ITEM (PERFORMANCE)
//--------------------------------------
class _CharacterItem extends StatelessWidget {
  final String character;
  final int index;
  final bool isSelected;
  final ValueChanged<int> onTap;
  final ColorScheme scheme;

  const _CharacterItem({
    required this.character,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Center(
        child: Text(
          " $character ",
          style: TextStyle(
            // fontFamily: "UthmanicHafs",
            fontFamily: "Hafs",
            fontSize: 20.sp,
            color: isSelected ? scheme.primary : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

//--------------------------------------
// STATELESS DATA CARD (PERFORMANCE)
//--------------------------------------
class _DataCard extends StatelessWidget {
  final String text;
  final ColorScheme scheme;

  const _DataCard({
    required this.text,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    print(text);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.primary.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: RichText(
          text: TextSpan(
            children: parseArabicText(text.replaceAll("،", ",")),
            style: TextStyle(
              fontSize: 17,
              height: 2,
              color: scheme.onSurface,
              fontFamily: "Hafs",
            ),
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

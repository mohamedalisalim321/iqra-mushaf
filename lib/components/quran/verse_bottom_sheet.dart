import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iqra/services/audio_service.dart';

import '../../database/verse_data_database.dart';
import '../../models/quran/verse.dart';
import '../../models/quran/verse_data.dart';
import '../../utils/utils.dart';

class VerseBottomSheet extends StatefulWidget {
  final Verse verse;

  const VerseBottomSheet({super.key, required this.verse});

  @override
  State<VerseBottomSheet> createState() => VerseBottomSheetState();
}

class VerseBottomSheetState extends State<VerseBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<String> _characters;
<<<<<<< HEAD
<<<<<<< HEAD

  List<VerseData>? _cachedVerseData;
  bool _loadingData = true;
=======
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
  late final ScrollController _scrollController;

  List<VerseData>? _cachedVerseData;
  bool _loadingData = true;

<<<<<<< HEAD
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
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

<<<<<<< HEAD
<<<<<<< HEAD
  // --------------------------
  // Load & Cache Verse Data
  // --------------------------
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
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

<<<<<<< HEAD
<<<<<<< HEAD
  // --------------------------
  // Parse Characters
  // --------------------------
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
  List<String> _parseCharacters() {
    final text =
        "${widget.verse.verseText} ${widget.verse.verseNumber.toArabicDigits()}";
    return text.split(" ").where((c) => c.trim().isNotEmpty).toList();
  }

  void _onCharacterSelected(int index) {
<<<<<<< HEAD
<<<<<<< HEAD
    if (index < 0 || index >= _characters.length) return;
=======
    if (index < 0 ||
        index >= _characters.length - 1 ||
        index == _selectedCharIndex) return;
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
    if (index < 0 ||
        index >= _characters.length - 1 ||
        index == _selectedCharIndex) return;
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64

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

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildHandle() {
    final scheme = Theme.of(context).colorScheme;

=======
  Widget _buildHandle(ColorScheme scheme) {
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
  Widget _buildHandle(ColorScheme scheme) {
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
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

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildCharacterSelector() {
    return SizedBox(
      height: 90.h,
=======
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
  Widget _buildCharacterSelector(ColorScheme scheme) {
    return Container(
      height: 90.h,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.h),
<<<<<<< HEAD
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _characters.length,
        itemExtent: null,
        cacheExtent: 500,
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

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildCharacterItem(String char, int index, bool selected) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _onCharacterSelected(index),
      child: Center(
        child: Text(
          char,
          style: TextStyle(
            fontFamily: "UthmanicHafs",
            fontSize: 20.sp,
            color: selected ? scheme.primary : scheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildWordDataSection() {
=======
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
  //--------------------------------------
  // WORD DATA SECTION
  //--------------------------------------
  Widget _buildWordDataSection(ColorScheme scheme) {
<<<<<<< HEAD
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
    if (_loadingData) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            indicatorColor: Theme.of(context).colorScheme.primary,
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

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildWordData() {
    if (_cachedVerseData == null || _cachedVerseData!.isEmpty) {
      return _buildErrorState();
=======
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
  //--------------------------------------
  // CACHED WORD-DATA READER
  //--------------------------------------
  Widget _buildWordData(ColorScheme scheme) {
    if (_cachedVerseData == null || _cachedVerseData!.isEmpty) {
      return _buildErrorState(scheme);
<<<<<<< HEAD
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
    }

    final safeIndex = _selectedCharIndex.clamp(0, _cachedVerseData!.length - 1);
    final data = _cachedVerseData![safeIndex];

    return TabBarView(
      controller: _tabController,
      children: [
<<<<<<< HEAD
<<<<<<< HEAD
        _buildDataCard(data.sarf),
        _buildDataCard(data.irab),
        _buildDataCard(data.wordMeaning),
=======
        _DataCard(text: data.sarf, scheme: scheme),
        _DataCard(text: data.irab, scheme: scheme),
        _DataCard(text: data.wordMeaning, scheme: scheme),
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
        _DataCard(text: data.sarf, scheme: scheme),
        _DataCard(text: data.irab, scheme: scheme),
        _DataCard(text: data.wordMeaning, scheme: scheme),
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
      ],
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildErrorState() {
    final scheme = Theme.of(context).colorScheme;

=======
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
  //--------------------------------------
  // ERROR
  //--------------------------------------
  Widget _buildErrorState(ColorScheme scheme) {
<<<<<<< HEAD
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
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
                color: scheme.onSurface.withOpacity(0.8)),
          ),
          SizedBox(height: 6.w),
          Text(
            "اختر حرفاً آخر لعرض التفاصيل",
            style: TextStyle(
                fontSize: 14.sp, color: scheme.onSurface.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildDataCard(String text) {
    final scheme = Theme.of(context).colorScheme;
=======
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
//--------------------------------------
// STATELESS CHARACTER ITEM (PERFORMANCE)
//--------------------------------------
class _CharacterItem extends StatelessWidget {
  final String character;
  final int index;
  final bool isSelected;
  final ValueChanged<int> onTap;
  final ColorScheme scheme;
<<<<<<< HEAD
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64

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
            fontFamily: "UthmanicHafs",
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.primary.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: scheme.shadow.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
<<<<<<< HEAD
<<<<<<< HEAD
        child: RichText(
          text: TextSpan(
            children: parseArabicText(text.replaceAll("،", ",")),
            style: TextStyle(
              fontSize: 17,
              height: 2,
              color: scheme.onSurface,
              fontFamily: "Hafs",
            ),
=======
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            height: 2,
            color: scheme.onSurface,
            fontFamily: "UthmanicHafs",
<<<<<<< HEAD
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../database/verse_data_database.dart';
import '../../models/quran/verse.dart';
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
  int _selectedCharIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _characters = _parseCharacters();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> _parseCharacters() {
    final text =
        "${widget.verse.verseText} ${widget.verse.verseNumber.toArabicDigits()}";

    return text.split(" ").where((c) => c.trim().isNotEmpty).toList();
  }

  void _onCharacterSelected(int index) {
    if (index < 0 || index >= _characters.length - 1) return;

    setState(() {
      _selectedCharIndex = index;
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _isLoading = false);
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
            _buildHandle(),
            _buildCharacterSelector(),
            Expanded(child: _buildWordDataSection()),
          ],
        ),
      ),
    );
  }

  //--------------------------------------
  // HANDLE
  //--------------------------------------
  Widget _buildHandle() {
    final scheme = Theme.of(context).colorScheme;

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

  //--------------------------------------
  // CHARACTER SELECTOR
  //--------------------------------------
  Widget _buildCharacterSelector() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      decoration: BoxDecoration(
        color: scheme.surface,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: false,
        itemCount: _characters.length,
        itemBuilder: (_, i) {
          final selected = _selectedCharIndex == i;
          return _buildCharacterItem(_characters[i], i, selected);
        },
      ),
    );
  }

  Widget _buildCharacterItem(String char, int index, bool selected) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _onCharacterSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.w),
        margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 4.w),
        decoration: BoxDecoration(
          color:
              selected ? scheme.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: selected ? Border.all(color: scheme.primary, width: 1) : null,
        ),
        child: Center(
          child: Text(
            char,
            style: TextStyle(
              fontFamily: "UthmanicHafs",
              fontSize: 20.sp,
              color: selected ? scheme.primary : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  //--------------------------------------
  // WORD DATA SECTION
  //--------------------------------------
  Widget _buildWordDataSection() {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(
              bottom: BorderSide(color: scheme.primary.withOpacity(0.2)),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: scheme.primary,
            unselectedLabelColor: scheme.onSurface.withOpacity(0.5),
            indicatorColor: scheme.primary,
            indicatorWeight: 3,
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: "الصرف"),
              Tab(text: "الإعراب"),
              Tab(text: "المعنى"),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildWordData(),
        ),
      ],
    );
  }

  //--------------------------------------
  // FUTURE BUILDER
  //--------------------------------------
  Widget _buildWordData() {
    return FutureBuilder(
      key: ValueKey(_selectedCharIndex),
      future: VerseDataDatabase.getVerseData(
        widget.verse.surahNumber,
        widget.verse.verseNumber,
        _selectedCharIndex + 1,
      ),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorState();
        }

        final data = snapshot.data!;

        return TabBarView(
          controller: _tabController,
          children: [
            _buildDataCard(data.sarf),
            _buildDataCard(data.irab),
            _buildDataCard(data.wordMeaning),
          ],
        );
      },
    );
  }

  //--------------------------------------
  // ERROR STATE
  //--------------------------------------
  Widget _buildErrorState() {
    final scheme = Theme.of(context).colorScheme;

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

  //--------------------------------------
  // DATA CARD
  //--------------------------------------
  Widget _buildDataCard(String text) {
    final scheme = Theme.of(context).colorScheme;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 17,
                height: 2,
                color: scheme.onSurface,
                fontFamily: "Hafs",
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}

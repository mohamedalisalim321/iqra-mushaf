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

  List<VerseData>? _cachedVerseData;
  bool _loadingData = true;
  int _selectedCharIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _characters = _parseCharacters();

    _loadAndCacheVerseData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --------------------------
  // Load & Cache Verse Data
  // --------------------------
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

  // --------------------------
  // Parse Characters
  // --------------------------
  List<String> _parseCharacters() {
    final text =
        "${widget.verse.verseText} ${widget.verse.verseNumber.toArabicDigits()}";
    return text.split(" ").where((c) => c.trim().isNotEmpty).toList();
  }

  void _onCharacterSelected(int index) {
    if (index < 0 || index >= _characters.length) return;

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

  Widget _buildCharacterSelector() {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildWordData(),
        ),
      ],
    );
  }

  Widget _buildWordData() {
    if (_cachedVerseData == null || _cachedVerseData!.isEmpty) {
      return _buildErrorState();
    }

    final safeIndex = _selectedCharIndex.clamp(0, _cachedVerseData!.length - 1);
    final data = _cachedVerseData![safeIndex];

    return TabBarView(
      controller: _tabController,
      children: [
        _buildDataCard(data.sarf),
        _buildDataCard(data.irab),
        _buildDataCard(data.wordMeaning),
      ],
    );
  }

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

  Widget _buildDataCard(String text) {
    final scheme = Theme.of(context).colorScheme;

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

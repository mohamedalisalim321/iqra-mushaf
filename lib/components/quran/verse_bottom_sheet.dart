import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iqra/utils/utils.dart';

import '../../database/verse_data_database.dart';
import '../../models/quran/verse.dart';

class VerseBottomSheet extends StatefulWidget {
  final Verse verse;
  final String fontFamily;

  const VerseBottomSheet({
    super.key,
    required this.verse,
    required this.fontFamily,
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
        "${widget.verse.verseText} ${widget.verse.verseNumber.toArabicNumber()}";

    return text.split(" ").where((char) => char.trim().isNotEmpty).toList();
  }

  void _onCharacterSelected(int index) {
    if (index < 0 || index >= _characters.length - 1) return;
    setState(() {
      _selectedCharIndex = index;
      _isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              _buildHandle(),
              const Divider(height: 1),
              _buildCharacterSelector(),
              const SizedBox(height: 12),
              Expanded(child: _buildWordDataSection()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildCharacterSelector() {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: _characters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCharIndex == index;

          return _buildCharacterItem(
            _characters[index],
            index,
            isSelected,
          );
        },
      ),
    );
  }

  Widget _buildCharacterItem(
    String char,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => _onCharacterSelected(index),
      child: Center(
        child: Text(
          "   $char   ",
          style: TextStyle(
            fontFamily: widget.fontFamily,
            fontSize: 18,
            color: (isSelected ? Colors.blue : Colors.black87),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildWordDataSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.blue.shade700,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: Colors.blue.shade700,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: "الصرف",
              ),
              Tab(
                text: "الإعراب",
              ),
              Tab(
                text: "المعنى",
              ),
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
    return FutureBuilder(
      key: ValueKey(_selectedCharIndex),
      future: VerseDataDatabase.getVerseData(
        widget.verse.surahNumber,
        widget.verse.verseNumber,
        _selectedCharIndex + 1,
      ),
      builder: (context, snapshot) {
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
            _buildDataCard(data.sarf, "الصرف", Icons.text_fields),
            _buildDataCard(data.irab, "الإعراب", Icons.format_list_bulleted),
            _buildDataCard(data.wordMeaning, "المعنى", Icons.translate),
          ],
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات متاحة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر حرفاً آخر لعرض التفاصيل',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String text, String title, IconData icon) {
    if (text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'لا توجد بيانات $title',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                height: 2.0,
                color: Colors.black87,
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

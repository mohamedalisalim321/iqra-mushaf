import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/quran/surah_header.dart';
import '../../components/quran/verse_bottom_sheet.dart';
import '../../database/surah_database.dart';
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
  List<Surah> _surahs = [];
  final Map<int, Widget> _pageCache = {};
  final List<LongPressGestureRecognizer> _recognizers = [];

  late PageController _pageController;

  Verse? _selectedVerse;
  int _currentPage = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _safeInit();
  }

  Future<void> _safeInit() async {
    _currentPage = widget.surahIndex.clamp(1, 604);

    _pageController = PageController(initialPage: _currentPage - 1);

    await _loadSurahs();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    try {
      final s = await SurahDatabase.getAllSurahs();
      if (!mounted) return;

      setState(() {
        _surahs = s;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR LOADING SURAHS $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
      _showErrorSnackBar("فشل تحميل السور");
    }
  }

  void _navigateToSurah(int surahIndex) {
    final pageNumber = SurahDatabase.getPageNumber(surahIndex, 1) - 1;

    if (_pageController.hasClients) {
      _pageController.jumpToPage(pageNumber);
      setState(() => _currentPage = pageNumber + 1);
      Navigator.pop(context);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6,
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showVerseSheet(Verse verse, String fontFamily) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.2),
      barrierColor: Colors.black54,
      builder: (_) => VerseBottomSheet(
        verse: verse,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EF),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildPageView(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      shadowColor: Colors.black12,
      title: Text(
        "صفحة $_currentPage",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  // ----------------------------------------------------
  // Drawer UI
  // ----------------------------------------------------
  Widget _buildDrawer() {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
      child: Drawer(
        elevation: 8,
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSurahList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary
          ],
        ),
      ),
      child: const DrawerHeader(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              'السور',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSurahList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      separatorBuilder: (_, __) => Divider(
          height: 1, indent: 60, endIndent: 10, color: Colors.grey[300]),
      itemCount: _surahs.length,
      itemBuilder: (_, i) {
        final s = _surahs[i];
        final isCurrent = _isCurrentSurah(s.surahIndex);

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            color: isCurrent
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.transparent,
            child: ListTile(
              onTap: () => _navigateToSurah(s.surahIndex),
              leading: _buildSurahNumber(s.surahIndex, isCurrent),
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  s.surahName,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
              subtitle: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${s.versesCount} آية",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isCurrent
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurahNumber(int num, bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active
            ? LinearGradient(colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ])
            : null,
        color: active ? null : Colors.grey[700],
        boxShadow: active
            ? [
                BoxShadow(
                  blurRadius: 8,
                  color: Theme.of(context).primaryColor.withOpacity(.3),
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          "$num",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  bool _isCurrentSurah(int surahIndex) {
    final page = SurahDatabase.getPageNumber(surahIndex, 1);
    return page == _currentPage;
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      reverse: false,
      itemCount: 604,
      onPageChanged: _onPageChanged,
      itemBuilder: (_, i) => FutureBuilder<Widget>(
        future: _buildPage(i + 1),
        builder: (_, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) return _buildErrorPage(i + 1);
          return s.data ?? const SizedBox();
        },
      ),
    );
  }

  Widget _buildErrorPage(int page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, size: 70, color: Colors.red[400]),
        const SizedBox(height: 10),
        Text(
          "تعذّر تحميل الصفحة $page",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        TextButton.icon(
          onPressed: () => setState(() => _pageCache.remove(page)),
          icon: const Icon(Icons.refresh),
          label: const Text("إعادة المحاولة"),
        ),
      ],
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page + 1;
      _selectedVerse = null;
    });
  }

  Future<Widget> _buildPage(int page) async {
    final ranges = SurahDatabase.getPageData(page);
    final font = "QCF_P${page.toString().padLeft(3, '0')}";
    final fontSize = getFontSize(page, context).sp;

    final spans = <InlineSpan>[];

    if (page <= 2) {
      spans.add(WidgetSpan(child: SizedBox(height: 110.h)));
    }

    // dispose old recognizers
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    for (final r in ranges) {
      await _addRange(spans, r, page, font);
    }

    final widget = RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: spans,
        style: TextStyle(
          fontFamily: font,
          fontSize: fontSize,
          height: 2.h,
          color: Colors.black,
        ),
      ),
    );

    return widget;
  }

  Future<void> _addRange(
    List<InlineSpan> spans,
    Map<String, int> range,
    int page,
    String font,
  ) async {
    final surah = range["surah"]!;
    final start = range["start"]!;
    final end = range["end"]!;

    for (int v = start; v <= end; v++) {
      if (v == 1 && v == start) {
        _addSurahHeader(spans, surah, page);
      }

      await _addVerse(spans, surah, v, font, isFirst: v == start);
    }
  }

  void _addSurahHeader(List<InlineSpan> spans, int surah, int page) {
    spans.add(
      WidgetSpan(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: SurahHeader(suraNumber: surah),
        ),
      ),
    );

    if (page != 1 && page != 187) {
      final special = surah == 97;

      spans.add(
        TextSpan(
          text: "${special ? "齃𧻓𥳐龎" : " ﱁ  ﱂﱃﱄ"}\n",
          style: TextStyle(
            fontFamily: special ? "QCF_BSML" : "QCF_P001",
            fontSize: 26.sp,
          ),
        ),
      );
    }
  }

  Future<void> _addVerse(
    List<InlineSpan> spans,
    int surah,
    int verse,
    String font, {
    required bool isFirst,
  }) async {
    final v = await SurahDatabase.getVerseQcf(surah, verse);

    final txt =
        isFirst ? "${v.qcfData[0]}\u200A${v.qcfData.substring(1)}" : v.qcfData;

    final recognizer = LongPressGestureRecognizer()
      ..onLongPress = () {
        if (!mounted) return;
        setState(() => _selectedVerse = v);
        _showVerseSheet(v, font);
      };

    _recognizers.add(recognizer);

    final isSelected = _selectedVerse != null &&
        _selectedVerse!.surahNumber == v.surahNumber &&
        _selectedVerse!.verseNumber == v.verseNumber;

    spans.add(
      TextSpan(
        text: txt,
        recognizer: recognizer,
        style: TextStyle(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
          color: Colors.black,
        ),
      ),
    );
  }
}

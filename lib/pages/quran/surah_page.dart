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

  /// Ensures PageController is ALWAYS initialized
  Future<void> _safeInit() async {
    _currentPage = widget.surahIndex.clamp(1, 604);

    // Initialize here safely
    _pageController = PageController(initialPage: _currentPage - 1);

    await _loadSurahs();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _disposeRecognizers();
    _pageController.dispose();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
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
      _showErrorSnackBar("Failed to load surahs");
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
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showVerseSheet(Verse verse, String fontFamily) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VerseBottomSheet(
        verse: verse,
        fontFamily: fontFamily,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF7),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildPageView(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text("صفحة $_currentPage",
          style: const TextStyle(fontWeight: FontWeight.w600)),
      centerTitle: true,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
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
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary
          ],
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book, size: 48, color: Colors.white),
          SizedBox(height: 12),
          Text(
            'السور',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildSurahList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 70),
      itemCount: _surahs.length,
      itemBuilder: (_, i) {
        final s = _surahs[i];
        final isCurrent = _isCurrentSurah(s.surahIndex);

        return ListTile(
          onTap: () => _navigateToSurah(s.surahIndex),
          selected: isCurrent,
          selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
          leading: _buildSurahNumber(s.surahIndex, isCurrent),
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(s.surahName,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600)),
          ),
          subtitle: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${s.versesCount} آية",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios,
              size: 16,
              color: isCurrent ? Theme.of(context).primaryColor : null),
        );
      },
    );
  }

  Widget _buildSurahNumber(int num, bool active) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active
            ? LinearGradient(colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary
              ])
            : null,
        color: active ? null : Theme.of(context).primaryColor,
        boxShadow: active
            ? [
                BoxShadow(
                    blurRadius: 8,
                    color: Theme.of(context).primaryColor.withOpacity(.3),
                    offset: const Offset(0, 2))
              ]
            : null,
      ),
      child: Center(
        child: Text(
          "$num",
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
      reverse: true,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red[300]),
          const SizedBox(height: 8),
          Text("Error loading page $page",
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          TextButton.icon(
            onPressed: () => setState(() => _pageCache.remove(page)),
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          )
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page + 1;
      _selectedVerse = null;
    });
    _manageCache();
  }

  void _manageCache() {
    const max = 7;
    const range = 3;

    if (_pageCache.length <= max) return;

    final remove =
        _pageCache.keys.where((k) => (k - _currentPage).abs() > range).toList();

    for (final k in remove) {
      _pageCache.remove(k);
      if (_pageCache.length <= max) break;
    }
  }

  Future<Widget> _buildPage(int page) async {
    if (_pageCache.containsKey(page)) return _pageCache[page]!;

    final ranges = SurahDatabase.getPageData(page);
    final font = "QCF_P${page.toString().padLeft(3, '0')}";
    final fontSize = getFontSize(page, context).sp;

    final spans = <InlineSpan>[];

    if (page <= 2) {
      spans.add(WidgetSpan(child: SizedBox(height: 110.h)));
    }

    _disposeRecognizers();

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
          height: 2,
          color: Colors.black87,
        ),
      ),
    );

    _pageCache[page] = widget;
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
    spans.add(WidgetSpan(child: SurahHeader(suraNumber: surah)));

    if (page != 1 && page != 187) {
      final special = surah == 97;
      spans.add(TextSpan(
        text: special ? "\n齃𧻓𥳐龎" : "\n ﱁ  ﱂﱃﱄ",
        style: TextStyle(
            fontFamily: special ? "QCF_BSML" : "QCF_P001", fontSize: 24.sp),
      ));
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
          backgroundColor: isSelected ? Colors.yellow.withOpacity(.4) : null,
          color: Colors.black,
        ),
      ),
    );
  }
}

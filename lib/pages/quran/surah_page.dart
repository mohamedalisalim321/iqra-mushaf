import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/quran/surah_header.dart';
import '../../components/quran/verse_bottom_sheet.dart';
import '../../database/surah_database.dart';
import '../../models/quran/verse.dart';
import '../../providers/page_font_size.dart';

class SurahPage extends StatefulWidget {
  final int pageNumber;
  const SurahPage({super.key, required this.pageNumber});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage>
    with SingleTickerProviderStateMixin {
  final Map<int, Widget> _pageCache = {};
  final List<LongPressGestureRecognizer> _recognizers = [];

  late PageController _pageController;

  Verse? _selectedVerse;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _safeInit();
  }

  Future<void> _safeInit() async {
    _currentPage = widget.pageNumber.clamp(1, 604);

    _pageController = PageController(initialPage: _currentPage - 1);

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

  Widget _buildPageView() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
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
          ),
        ),
        Text(_currentPage.toString()),
      ],
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
          color: Colors.black,
          height: 2.0.h,
          wordSpacing: 0,
          letterSpacing: 0,
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
        child: SurahHeader(suraNumber: surah),
      ),
    );

    if (page != 1 && page != 187) {
      spans.add(
        TextSpan(
          text: "齃𧻓𥳐龎\n",
          style: TextStyle(
            fontFamily: "QCF_BSML",
            fontSize:
                getScreenType(context) == ScreenType.large ? 13.2.sp : 18.sp,
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

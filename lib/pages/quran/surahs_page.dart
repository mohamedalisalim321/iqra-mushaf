import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/quran/surah_tile.dart';
import '../../database/surah_database.dart';
import '../../models/quran/surah.dart';
import '../settings/settings_page.dart';
import 'surah_page.dart';

class SurahsPage extends StatefulWidget {
  const SurahsPage({super.key});

  @override
  State<SurahsPage> createState() => _SurahsPageState();
}

class _SurahsPageState extends State<SurahsPage> {
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];

  final TextEditingController _controller = TextEditingController();
  final Duration _searchDebounceDuration = const Duration(milliseconds: 200);

  Timer? _debounce;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    try {
      final list = await SurahDatabase.getAllSurahs();

      setState(() {
        _allSurahs = list;
        _filteredSurahs = list;
        _isLoading = false;
      });
    } catch (e) {
      _showError("حدث خطأ أثناء تحميل السور. يرجى المحاولة لاحقًا.");
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(_searchDebounceDuration, () {
      _filterSurahs(query);
    });
  }

  void _filterSurahs(String query) {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() => _filteredSurahs = _allSurahs);
      return;
    }

    final lower = trimmed.toLowerCase();
    final results = _allSurahs.where((s) {
      return s.surahName.contains(trimmed) ||
          s.surahNameTr.toLowerCase().contains(lower);
    }).toList();

    setState(() => _filteredSurahs = results);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openSurah(Surah surah) {
    final firstPage = SurahDatabase.getPageNumber(surah.surahIndex, 1);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahPage(surahIndex: firstPage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("القرآن الكريم"),
        centerTitle: true,
        backgroundColor: colors.secondary,
        elevation: 3,
        leading: IconButton.filled(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            );
          },
          icon: Icon(Icons.settings_rounded),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TextField(
                controller: _controller,
                onChanged: _onSearchChanged,
                textAlign: TextAlign.right,
                style: TextStyle(color: colors.onSurface),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: colors.primary),
                  hintText: "ابحث عن سورة...",
                  hintStyle: TextStyle(
                    color: colors.onSurface.withOpacity(0.7),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: colors.primary,
                    ),
                  )
                : _filteredSurahs.isEmpty
                    ? Center(
                        child: Text(
                          "لا توجد سورة بهذا الاسم",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: colors.primary,
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 250),
                        child: ListView.separated(
                          padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
                          itemCount: _filteredSurahs.length,
                          separatorBuilder: (_, __) => SizedBox(height: 6.h),
                          itemBuilder: (_, i) {
                            final surah = _filteredSurahs[i];
                            return SurahTile(
                              surah: surah,
                              onTap: () => _openSurah(surah),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

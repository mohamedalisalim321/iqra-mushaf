import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/my_searchbar.dart';
import '../../components/quran/surah_tile.dart';
import '../../database/surah_database.dart';
import '../../models/quran/surah.dart';
import '../settings/settings_page.dart';
import 'surah_page.dart';

class SurahsListPage extends StatefulWidget {
  const SurahsListPage({super.key});

  @override
  State<SurahsListPage> createState() => _SurahsListPageState();
}

class _SurahsListPageState extends State<SurahsListPage> {
  static const _kTotalQuranPages = 604;
  static const _kSearchDebounceDuration = Duration(milliseconds: 200);

  final TextEditingController _searchController = TextEditingController();

  Timer? _debounceTimer;
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  int? _searchedPageNumber;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    try {
      final surahs = await SurahDatabase.getAllSurahs();
      if (!mounted) return;

      setState(() {
        _allSurahs = surahs;
        _filteredSurahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      _showError('حدث خطأ أثناء تحميل السور. يرجى المحاولة لاحقًا.');
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(_kSearchDebounceDuration, () {
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        _clearSearch();
        return;
      }

      final pageNum = int.tryParse(trimmed);
      if (pageNum != null && pageNum >= 1 && pageNum <= _kTotalQuranPages) {
        _handlePageSearch(pageNum);
      } else {
        _handleSurahSearch(trimmed.toLowerCase());
      }
    });
  }

  void _clearSearch() {
    if (!mounted) return;
    setState(() {
      _filteredSurahs = _allSurahs;
      _searchedPageNumber = null;
    });
  }

  void _handlePageSearch(int page) {
    if (!mounted) return;
    setState(() {
      _filteredSurahs = [];
      _searchedPageNumber = page;
    });
  }

  void _handleSurahSearch(String lowerQuery) {
    if (!mounted) return;
    final results = _allSurahs.where((surah) {
      return surah.surahName.toLowerCase().contains(lowerQuery) ||
          surah.surahNameTr.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _filteredSurahs = results;
      _searchedPageNumber = null;
    });
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
      MaterialPageRoute(builder: (_) => SurahPage(pageNumber: firstPage)),
    );
  }

  void _openPage(int page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SurahPage(pageNumber: page)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _buildAppBar(colors),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: MySearchbar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: "ابحث عن سورة أو رقم صفحة...",
            ),
          ),
          Expanded(
            child: _buildContent(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ColorScheme colors) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: TextStyle(color: colors.error, fontSize: 18.sp),
        ),
      );
    }

    // Page number search result
    if (_searchedPageNumber != null) {
      return _buildPageResult(colors);
    }

    // Surah search results
    if (_filteredSurahs.isEmpty) {
      return Center(
        child: Text(
          "لا توجد سورة بهذا الاسم",
          style: TextStyle(fontSize: 18.sp, color: colors.primary),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
      itemCount: _filteredSurahs.length,
      itemBuilder: (context, index) {
        final surah = _filteredSurahs[index];
        return SurahTile(
          surah: surah,
          onTap: () => _openSurah(surah),
        );
      },
    );
  }

  Widget _buildPageResult(ColorScheme colors) {
    return Center(
      child: GestureDetector(
        onTap: () => _openPage(_searchedPageNumber!),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'الصفحة $_searchedPageNumber',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: colors.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(ColorScheme colors) {
    return AppBar(
      title: Text(
        "سور القرآن الكريم",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Lateef",
          fontSize: 24.sp,
        ),
      ),
      centerTitle: true,
      backgroundColor: colors.secondary,
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
        icon: const Icon(
          Icons.settings_rounded,
          color: Colors.white,
        ),
      ),
     
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/quran/surah_tile.dart';
import '../../database/surah_database.dart';
import '../../models/quran/surah.dart';
import 'surah_page.dart';

class SurahsPage extends StatefulWidget {
  const SurahsPage({super.key});

  @override
  State<SurahsPage> createState() => _SurahsPageState();
}

class _SurahsPageState extends State<SurahsPage> {
  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  final _controller = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    try {
      final list = await SurahDatabase.getAllSurahs();
      setState(() {
        _allSurahs = list;
        _filteredSurahs = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error loading Surahs. Please try again later.'),
        ),
      );
    }
  }

  void _filterSurahs(String query) {
    if (query.isEmpty) {
      setState(() => _filteredSurahs = _allSurahs);
      return;
    }

    setState(() {
      _filteredSurahs = _allSurahs.where((s) {
        return s.surahName.contains(query) ||
            s.surahNameTr.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("القرآن الكريم"),
        centerTitle: true,
        elevation: 4,
        backgroundColor: colors.secondary,
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
                onChanged: _filterSurahs,
                textAlign: TextAlign.right,
                style: TextStyle(color: colors.onSurface),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  prefixIcon: Icon(Icons.search, color: colors.primary),
                  hintText: "أبحث في سور القرآن الكريم...",
                  hintStyle: TextStyle(
                    color: colors.onSurface.withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: colors.secondary,
                    ),
                  )
                : _filteredSurahs.isEmpty
                    ? Center(
                        child: Text(
                          "لا توجد سورة بهذا الاسم",
                          style:
                              TextStyle(fontSize: 18.sp, color: colors.primary),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
                        itemCount: _filteredSurahs.length,
                        separatorBuilder: (_, __) => SizedBox(height: 6.h),
                        itemBuilder: (context, i) {
                          final surah = _filteredSurahs[i];
                          return SurahTile(
                            surah: surah,
                            onTap: () {
                              final firstPage = SurahDatabase.getPageNumber(
                                  surah.surahIndex, 1);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SurahPage(surahIndex: firstPage),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

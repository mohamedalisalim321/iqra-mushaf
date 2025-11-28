import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/quran/surah_tile.dart';
import '../database/surah_database.dart';
import '../models/quran/surah.dart';
import 'settings_page.dart';
import 'surah_page.dart';

class SurahsPage extends StatefulWidget {
  const SurahsPage({super.key});

  @override
  State<SurahsPage> createState() => _SurahsPageState();
}

class _SurahsPageState extends State<SurahsPage> {
  late Future<List<Surah>> _futureSurahs;

  List<Surah> _allSurahs = [];

  @override
  void initState() {
    super.initState();
    loadSurahs();
  }

  void loadSurahs() async {
    final list = await SurahDatabase.getAllSurahs();
    setState(() {
      _allSurahs = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("القرآن الكريم"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
      ),
      body: FutureBuilder(
        future: _futureSurahs,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return _allSurahs.isEmpty
              ? const Center(
                  child: Text(
                    "لا توجد سورة بهذا الاسم",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _allSurahs.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, i) {
                    final surah = _allSurahs[i];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SurahTile(
                        surah: surah,
                        onTap: () {
                          final firstPage = SurahDatabase.getPageNumber(
                            surah.surahIndex,
                            1,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurahPage(surahIndex: firstPage),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

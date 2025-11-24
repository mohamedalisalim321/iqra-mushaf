import 'package:flutter/material.dart';

import '../components/quran/surah_tile.dart';
import '../database/surah_database.dart';
import '../models/quran/surah.dart';
import '../providers/quran.dart';
import 'surah_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Surah> surahsList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await SurahDatabase.seedIfNeeded();
    final sList = await SurahDatabase.getAllSurahs();
    setState(() {
      surahsList = sList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "القرآن الكريم",
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green.shade200,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.settings_rounded),
        ),
      ),
      body: surahsList.isEmpty
          ? const Center(child: Text("لا توجد سورة بهذا الاسم"))
          : ListView.builder(
              itemCount: surahsList.length,
              itemBuilder: (context, index) {
                final surah = surahsList[index];

                return SurahTile(
                  surah: surah,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahPage(
                          surahIndex: getPageNumber(surah.surahIndex, 1),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

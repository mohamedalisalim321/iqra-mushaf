import 'package:flutter/material.dart';

import '../database/surah_database.dart';
import '../services/notification_service.dart';
import 'quran/surahs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SurahsPage(),
                  ),
                );
              },
              child: Text("Quran Page"),
            ),
            FilledButton(
              onPressed: () async {
                final verse = await SurahDatabase.getRandomVerse();
                await NotificationService.instance.show(
                  title: verse!.surahName,
                  body: verse.verseText,
                );
              },
              child: const Text("Send A Notification"),
            ),
          ],
        ),
      ),
    );
  }
}

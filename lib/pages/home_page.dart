import 'package:flutter/material.dart';

import '../database/surah_database.dart';
import '../services/notification_service.dart';
import 'quran/surahs_list_page.dart';
import 'settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
          icon: const Icon(Icons.settings_rounded),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SurahsListPage(),
                    ),
                  );
                },
                child: const Text(
                  "Go to Quran Page",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  try {
                    final verse = await SurahDatabase.getRandomVerse();
                    if (verse != null) {
                      await NotificationService.instance.show(
                        title: verse.surahName,
                        body: verse.verseText,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No verse found.')),
                      );
                    }
                  } catch (e) {
                    // Handling any error that occurs during the async call
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error fetching verse.')),
                    );
                  }
                },
                child: const Text(
                  "Send A Notification",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

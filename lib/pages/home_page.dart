import 'package:flutter/material.dart';
import 'package:iqra/pages/quran/surahs_page.dart';
import 'package:iqra/services/notification_service.dart';

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
                await NotificationService.instance.show(
                  title: "Hi",
                  body: "Buy",
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

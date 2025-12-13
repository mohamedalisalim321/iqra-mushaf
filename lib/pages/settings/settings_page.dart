import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:iqra/database/reciters_database.dart';
import 'package:iqra/services/audio_service.dart';
import 'package:provider/provider.dart';

import '../../models/quran/reciter.dart';
=======
import 'package:provider/provider.dart';

>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
import '../../themes/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Reciter> reciters = [];
  String? selectedReciterId;
  final audioService = AudioService.instance;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final r = await RecitersDatabase.getAllReciters();
    setState(() {
      reciters = r;
      selectedReciterId = audioService.currentReciter.value?.identifier ??
          (r.isNotEmpty ? r.first.identifier : null);

      // Ensure AudioService has a valid reciter
      if (audioService.currentReciter.value == null && reciters.isNotEmpty) {
        AudioService.instance.setReciter(reciters.first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final themeProvider = Provider.of<ThemeProvider>(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: scheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dark Mode Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Dark Mode", style: TextStyle(fontSize: 16)),
                CupertinoSwitch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Reciter Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Reciter", style: TextStyle(fontSize: 16)),
                Expanded(
                  child: reciters.isEmpty
                      ? const Text(
                          "Loading...",
                          textAlign: TextAlign.right,
                        )
                      : DropdownButton<String>(
                          value: selectedReciterId,
                          isExpanded: true,
                          underline: Container(),
                          items: reciters.map((r) {
                            return DropdownMenuItem<String>(
                              value: r.identifier,
                              child: Text(
                                r.name,
                                textAlign: TextAlign.right,
                              ),
                            );
                          }).toList(),
                          onChanged: (id) {
                            if (id == null) return;
                            setState(() => selectedReciterId = id);
                            final reciter =
                                reciters.firstWhere((r) => r.identifier == id);
                            AudioService.instance.setReciter(reciter);
                          },
                        ),
                ),
              ],
=======
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Page"),
      ),
      body: Center(
        child: Row(
          children: [
            Text("Dark Mode"),
            CupertinoSwitch(
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/quran/surah.dart';

class SurahTile extends StatelessWidget {
  final Surah surah;
  final void Function()? onTap;
  const SurahTile({super.key, required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        surah.surahName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

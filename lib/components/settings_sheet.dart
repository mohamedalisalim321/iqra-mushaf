import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../database/reciters_database.dart';
import '../models/quran/reciter.dart';
import '../providers/app_settings.dart';
import '../services/audio_service.dart';
import '../themes/theme_provider.dart';
import 'my_dropdown_button.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService.instance;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        builder: (_, __) => ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // ────────── Theme ──────────
            const _ThemeSection(),

            Divider(height: 32.h),

            // ────────── Audio ──────────
            _AudioSection(audioService: audioService),

            Divider(height: 32.h),

            // ────────── Fonts ──────────
            const _DisplaySection(),
          ],
        ),
      ),
    );
  }
}

/*──────────────────────── THEME ────────────────────────*/
class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProvider, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              "الوضع الداكن",
              style: TextStyle(
                fontFamily: "Lateef",
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: CupertinoSwitch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}

/*──────────────────────── AUDIO ────────────────────────*/
class _AudioSection extends StatelessWidget {
  const _AudioSection({required this.audioService});

  final AudioService audioService;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReciterSelector(audioService: audioService),
        ListTile(
          title: Text(
            'التشغيل التلقائي للايات',
            style: TextStyle(
              fontFamily: "Lateef",
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          trailing: ValueListenableBuilder<bool>(
            valueListenable: audioService.autoPlayNext,
            builder: (_, value, __) => CupertinoSwitch(
              value: value,
              onChanged: (_) => audioService.toggleAutoPlay(),
            ),
          ),
        ),
        
                ListTile(
          title: Text(
            "التنقل التلقائي بين اﻷيات",
            style: TextStyle(
              fontFamily: "Lateef",
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          trailing: ValueListenableBuilder<bool>(
            valueListenable: audioService.animateToCurrentVerse,
            builder: (_, value, __) => CupertinoSwitch(
              value: value,
              onChanged: (_) => audioService.toggleAnimtingVerse(),
            ),
          ),
        ),
        
        
      ],
    );
  }
}

class _ReciterSelector extends StatefulWidget {
  const _ReciterSelector({required this.audioService});

  final AudioService audioService;

  @override
  State<_ReciterSelector> createState() => _ReciterSelectorState();
}

class _ReciterSelectorState extends State<_ReciterSelector> {
  late Future<List<Reciter>> _recitersFuture;

  @override
  void initState() {
    super.initState();
    _recitersFuture = RecitersDatabase.getAllReciters();
  }

  @override
  Widget build(BuildContext context) {
    final audioService = widget.audioService;

    return FutureBuilder<List<Reciter>>(
      future: _recitersFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text('القارئ'),
            trailing: CircularProgressIndicator.adaptive(strokeWidth: 2),
          );
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const ListTile(
            title: Text('القارئ'),
            subtitle: Text('لا يوجد قراء متاحين',
                style: TextStyle(color: Colors.red)),
          );
        }

        final reciters = snapshot.data!;
        return ValueListenableBuilder<Reciter?>(
          valueListenable: audioService.currentReciter,
          builder: (_, currentReciter, __) {
            final selectedId =
                currentReciter?.identifier ?? reciters.first.identifier;
            return ListTile(
              title: Text(
                'القارئ',
                style: TextStyle(
                  fontFamily: "Lateef",
                  fontSize: 18.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: MyDropdownButton<String>(
                selectedValue: selectedId,
                dropdownItems: reciters
                    .map((r) => DropdownMenuItem(
                          value: r.identifier,
                          child: Text(
                            r.name,
                            style: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ))
                    .toList(),
                onChanged: (id) {
                  final reciter =
                      reciters.firstWhere((r) => r.identifier == id);
                  audioService.setReciter(reciter);
                },
              ),
            );
          },
        );
      },
    );
  }
}

/*──────────────────────── DISPLAY ────────────────────────*/
class _DisplaySection extends StatelessWidget {
  const _DisplaySection();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (_, settings, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'الخط العربي',
              style: TextStyle(
                fontFamily: "Lateef",
                fontSize: 18.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: MyDropdownButton<String>(
              selectedValue: settings.currentFont,
              dropdownItems: settings.fontsList
                  .map(
                    (font) => DropdownMenuItem(
                      value: font,
                      child: Text(
                        font,
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: 18.sp,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (fontName) => settings.changeCurrentFont(fontName!),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Row(
              children: [
                Text(
                  'حجم الخط العربي',
                  style: TextStyle(
                    fontFamily: "Lateef",
                    fontSize: 18.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: Slider(
                    min: 14,
                    max: 42,
                    label: settings.arabicFontSize.toStringAsFixed(0),
                    value: settings.arabicFontSize,
                    onChanged: settings.changeArabicFontSize,
                  ),
                ),
                Text(
                  settings.arabicFontSize.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: "Lateef",
                    fontSize: 18.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/my_dropdown_button.dart';
import '../../database/reciters_database.dart';
import '../../models/quran/reciter.dart';
import '../../providers/app_settings.dart';
import '../../services/audio_service.dart';
import '../../themes/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AudioService _audioService = AudioService.instance;
  List<Reciter>? _cachedReciters;

  @override
  void initState() {
    super.initState();
    _loadReciters();
  }

  Future<List<Reciter>> _loadReciters() async {
    if (_cachedReciters != null) return _cachedReciters!;

    try {
      final reciters = await RecitersDatabase.getAllReciters();

      if (_audioService.currentReciter.value == null && reciters.isNotEmpty) {
        _audioService.setReciter(reciters[reciters.length > 15 ? 15 : 0]);
      }

      _cachedReciters = reciters;
      return reciters;
    } catch (_) {
      return [];
    }
  }

  void _showDeveloperDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Mohamed Ali Salim",
            style: TextStyle(
              fontFamily: "Lora",
              fontSize: 24.sp,
            ),
          ),
          content: Column(
            children: [
              // my image
              Image.asset(
                "assets/images/mohamed_ali_salim.jpg",
              ),

              Text(
                "لقد جاهدت كي أخرج هذا التطبيق فإن أصبت فمن ٱللَّه وإن أخطأت فمن نفسي والشيطان",
                style: TextStyle(fontFamily: "Kufi", fontSize: 18.sp),
              ),

              IconButton(
                onPressed: () async {
                  final uri = Uri.parse(
                    'https://www.facebook.com/profile.php?id=61561233540084',
                  );

                  if (!await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw 'Could not launch $uri';
                  }
                },
                icon: Icon(
                  Icons.facebook_rounded,
                  size: 32.w,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colors.secondary,
        foregroundColor: Colors.white,
        title: Text(
          'الإعدادات',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lateef",
            fontSize: 24.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            const _ThemeSection(),
            const Divider(height: 32),
            const _AudioSection(),
            const Divider(height: 32),
            const _DisplaySection(),
            FilledButton(
              onPressed: () => _showDeveloperDialog(),
              child: const Text("About The Developer"),
            ),
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
      builder: (_, themeProvider, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'المظهر'),
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
        );
      },
    );
  }
}

/*──────────────────────── AUDIO ────────────────────────*/
class _AudioSection extends StatelessWidget {
  const _AudioSection();

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'الصوت'),
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
            subtitle: Text(
              'لا يوجد قراء متاحين',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final reciters = snapshot.data!;
        final selectedId = audioService.currentReciter.value?.identifier ??
            reciters.first.identifier;

        return ListTile(
          title: Text(
            'القارئ',
            style: TextStyle(
              fontFamily: "Lateef",
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          trailing: ValueListenableBuilder<Reciter?>(
            valueListenable: audioService.currentReciter,
            builder: (_, value, __) {
              return MyDropdownButton<String>(
                selectedValue: value?.identifier ?? selectedId,
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
              );
            },
          ),
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
      builder: (_, settings, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'العرض'),
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
                    .map((font) => DropdownMenuItem(
                          value: font,
                          child: Text(
                            font,
                            style: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ))
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
                      min: 16,
                      max: 32,
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
        );
      },
    );
  }
}

/*──────────────────────── COMMON ────────────────────────*/
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "Lateef",
          fontSize: 24.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

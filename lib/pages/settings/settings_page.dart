import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  late final Future<List<Reciter>> _recitersFuture;
  final AudioService _audioService = AudioService.instance;

  @override
  void initState() {
    super.initState();
    _recitersFuture = _loadReciters();
  }

  Future<List<Reciter>> _loadReciters() async {
    final reciters = await RecitersDatabase.getAllReciters();

    if (_audioService.currentReciter.value == null && reciters.isNotEmpty) {
      _audioService.setReciter(reciters[reciters.length > 15 ? 15 : 0]);
    }

    return reciters;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _buildAppBar(colors),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: const [
            _ThemeSection(),
            Divider(height: 32),
            _AudioSection(),
            Divider(height: 32),
            _DisplaySection(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(ColorScheme colors) {
    return AppBar(
      centerTitle: true,
      backgroundColor: colors.secondary,
      title: Text(
        'الإعدادات',
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Lateef",
          fontSize: 24.sp,
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
              title: const Text('اختيار المظهر'),
              trailing: MyDropdownButton<AppTheme>(
                selectedValue: themeProvider.currentTheme,
                dropdownItems: AppTheme.values.map(_themeItem).toList(),
                onChanged: (theme) => themeProvider.setTheme(theme!),
              ),
            ),
          ],
        );
      },
    );
  }

  DropdownMenuItem<AppTheme> _themeItem(AppTheme theme) {
    const labels = {
      AppTheme.light: 'المظهر الفاتح',
      AppTheme.dark: 'الوضع الداكن',
      AppTheme.sepia: 'المظهر البني الداكن',
    };

    return DropdownMenuItem(
      value: theme,
      child: Text(labels[theme]!),
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
          title: const Text('تكرار الآيات'),
          trailing: CupertinoSwitch(
            value: audioService.autoPlayNext,
            onChanged: (_) => audioService.toggleAutoPlay(),
          ),
        ),
      ],
    );
  }
}

class _ReciterSelector extends StatelessWidget {
  const _ReciterSelector({required this.audioService});

  final AudioService audioService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reciter>>(
      future: RecitersDatabase.getAllReciters(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text('القارئ'),
            trailing: CircularProgressIndicator.adaptive(strokeWidth: 2),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const ListTile(
            title: Text('القارئ'),
            subtitle: Text(
              'فشل تحميل القرّاء',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final reciters = snapshot.data!;
        final selectedId = audioService.currentReciter.value?.identifier ??
            reciters.first.identifier;

        return ListTile(
          title: const Text(
            'القارئ',
            maxLines: 1,
          ),
          trailing: MyDropdownButton<String>(
            selectedValue: selectedId,
            dropdownItems: reciters
                .map(
                  (r) => DropdownMenuItem(
                    value: r.identifier,
                    child: Text(
                      r.name,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
                .toList(),
            onChanged: (id) {
              final reciter = reciters.firstWhere((r) => r.identifier == id);
              audioService.setReciter(reciter);
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

            /// Font selector
            ListTile(
              title: const Text('الخط العربي'),
              trailing: MyDropdownButton<String>(
                selectedValue: settings.currentFont,
                dropdownItems: settings.fontsList
                    .map(
                      (font) => DropdownMenuItem(
                        value: font,
                        child: Text(font, style: TextStyle(fontFamily: font)),
                      ),
                    )
                    .toList(),
                onChanged: (fontName) => settings.changeCurrentFont(fontName!),
              ),
            ),

            ListTile(
              title: const Text("الخط الغربي"),
              trailing: MyDropdownButton<String>(
                selectedValue: settings.currentEngFont,
                dropdownItems: settings.fontsEngList
                    .map(
                      (font) => DropdownMenuItem(
                        value: font,
                        child: Text(font, style: TextStyle(fontFamily: font)),
                      ),
                    )
                    .toList(),
                onChanged: (fontName) =>
                    settings.changeCurrentEngFont(fontName!),
              ),
            ),

            /// Font size slider
            // Text(
            //   'حجم الخط العربي: ${settings.arabicFontSize.toStringAsFixed(1)}',
            // ),
            // Slider(
            //   value: settings.arabicFontSize,
            //   // value: 20,r
            //   min: 16,
            //   max: 48,
            //   label: settings.arabicFontSize.toInt().toString(),
            //   onChanged: settings.changeArabicFontSize,
            // ),
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
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

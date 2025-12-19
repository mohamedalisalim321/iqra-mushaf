import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'database/app_database.dart';
// import 'pages/home_page.dart';
import 'pages/quran/surahs_list_page.dart';

import 'providers/app_settings.dart';
import 'services/audio_service.dart';
import 'themes/theme_provider.dart';
//import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Future.wait([
      AppDatabase.initialize(),
      AudioService.init(),
      AppSettings().init(),
      AppSettings().resetSettings(),
      //NotificationService.instance.init(),
    ]);
  } catch (e) {
    // Centralized error handling with more context
    print("Service initialization failed: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
      ],
      child: const IqraApp(),
    ),
  );
}

class IqraApp extends StatelessWidget {
  const IqraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      enableScaleText: () => false,
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(392.727, 800.727),
      builder: (context, child) => MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: const SurahsListPage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
        themeMode: ThemeMode.dark,
      ),
    );
  }
}

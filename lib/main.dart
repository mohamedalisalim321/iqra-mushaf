import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'database/app_database.dart';
import 'pages/home_page.dart';

import 'themes/theme_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.clearAll();
  try {
    await AppDatabase.initialize();
  } catch (e) {
    debugPrint("Database initialization failed: $e");
  }

  try {
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint("NotificationService initialization failed: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
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
        //locale: Locale("ar"),
        //supportedLocales: [Locale("ar"), Locale("en")],
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      ),
    );
  }
}

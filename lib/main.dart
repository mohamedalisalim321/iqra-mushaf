import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'database/app_database.dart';
import 'pages/surahs_page.dart';
import 'themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.initialize();

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
        debugShowCheckedModeBanner: false,
        home: const SurahsPage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      ),
    );
  }
}

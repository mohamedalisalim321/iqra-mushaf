import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'database/app_database.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.initialize();

  runApp(const Iqra());
}

class Iqra extends StatelessWidget {
  const Iqra({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      enableScaleText: () => false,
      minTextAdapt: true,
      designSize: const Size(392.72727272727275, 800.7272727272727),
      builder: (_, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      },
    );
  }
}

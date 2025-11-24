import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../providers/page_font_size.dart';

class SurahHeader extends StatelessWidget {
  final int suraNumber;
  const SurahHeader({super.key, required this.suraNumber});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: const BoxDecoration(),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: const AssetImage("assets/images/surah header.png"),
              width: getScreenType(context) == ScreenType.large ? 250 : 372,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "$suraNumber",
                style: TextStyle(
                  fontFamily: "arsura",
                  fontSize:
                      getScreenType(context) == ScreenType.large ? 16.sp : 29.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/page_font_size.dart';

class SurahHeader extends StatelessWidget {
  final int suraNumber;
  const SurahHeader({super.key, required this.suraNumber});

  static const _headerImage = AssetImage(
    "assets/images/surah header.png",
  );

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(context);

    final double imageWidth = screenType == ScreenType.large ? 250.w : 372.w;
    final double fontSize = screenType == ScreenType.large ? 16.sp : 29.sp;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: _headerImage,
            width: imageWidth,
          ),
          RichText(
            text: TextSpan(
              text: "$suraNumber",
              style: TextStyle(
                fontFamily: "arsura",
                fontSize: fontSize,
                color: Colors.black,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/page_font_size.dart';

class SurahHeader extends StatelessWidget {
  final int suraNumber;
  const SurahHeader({super.key, required this.suraNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: const AssetImage("assets/images/surah header.png"),
            width: getScreenType(context) == ScreenType.large ? 250.w : 372.w,
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
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../providers/page_font_size.dart';

// class SurahHeader extends StatelessWidget {
//   final int suraNumber;

//   const SurahHeader({
//     super.key,
//     required this.suraNumber,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenType = getScreenType(context);
//     final isLarge = screenType == ScreenType.large;

//     // Better responsive scaling
//     final double headerWidth = isLarge ? 220.w : 350.w;
//     final double numberFontSize = isLarge ? 18.sp : 30.sp;

//     return InkWell(
//       borderRadius: BorderRadius.circular(12.r),
//       splashColor: Colors.black12,
//       highlightColor: Colors.black12.withOpacity(0.06),
//       child: Container(
//         width: double.infinity,
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(vertical: 6.h),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Background Image
//             Image.asset(
//               "assets/images/surah header.png",
//               width: headerWidth,
//               fit: BoxFit.contain,
//             ),

//             // Surah Number
//             Text(
//               "$suraNumber",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: "arsura",
//                 fontSize: numberFontSize,
//                 color: Colors.black,
//                 height: 1.1,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

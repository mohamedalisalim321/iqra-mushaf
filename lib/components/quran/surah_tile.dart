import 'package:flutter/material.dart';
import 'package:iqra/models/quran/surah.dart';

class SurahTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback? onTap;
  const SurahTile({super.key, required this.surah, this.onTap});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Text(surah.surahNameTr),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(surah.surahName),
                Text(surah.versesCount.toString()),
              ],
            ),
            SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(16),
              child: Text(surah.surahIndex.toString()),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../models/quran/surah.dart';
// import '../../utils/utils.dart';

// class SurahTile extends StatelessWidget {
//   final Surah surah;
//   final VoidCallback? onTap;

//   const SurahTile({
//     super.key,
//     required this.surah,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12.r),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.w),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Row(
//           children: [
//             // ● Surah Number Circle
//             Container(
//               height: 42.h,
//               width: 42.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey.shade200,
//                 border: Border.all(
//                   color: Colors.grey.shade400,
//                   width: 1.3,
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 convertToArabicNumber(surah.surahIndex),
//                 style: TextStyle(
//                   fontFamily: "arsura",
//                   fontSize: 18.sp,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),

//             SizedBox(width: 14.w),

//             // ● Title + Subtitle Column
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Surah name + metadata
//                   Row(
//                     children: [
//                       Text(
//                         surah.surahNameTr,
//                         style: TextStyle(
//                           fontSize: 17.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),

//                       SizedBox(width: 8.w),

//                       // Verse count
//                       Text(
//                         "(${surah.versesCount})",
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 3.h),

//                   // Arabic name
//                   Text(
//                     surah.surahName,
//                     style: TextStyle(
//                       fontFamily: "arsura",
//                       fontSize: 16.sp,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

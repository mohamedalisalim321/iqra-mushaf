import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/quran/verse.dart';
import '../../utils/utils.dart';

class VerseTile extends StatelessWidget {
  final Verse verse;
  final void Function()? onTap;
  const VerseTile({
    super.key,
    required this.verse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        ),
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Text(
              "${verse.surahNumber.toArabicDigits()}. ${verse.surahName}",
              style: TextStyle(
                fontFamily: "Cairo",
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 8.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                "${verse.normalVerse} ${verse.verseNumber.toArabicDigits()}",
                style: TextStyle(
                  fontFamily: "Kufi",
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

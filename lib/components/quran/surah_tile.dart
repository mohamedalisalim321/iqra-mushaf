import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/quran/surah.dart';
import '../../utils/utils.dart';

class SurahTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback? onTap;

  const SurahTile({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Cache non-changing values to avoid repeated string operations on rebuilds
    final surahNum = convertToArabicNumber(surah.surahIndex);
    final ayahCount = convertToArabicNumber(surah.versesCount);
    final isMakki = surah.surahType == "مكية";

    return Padding(
      padding: EdgeInsets.all(8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: colorScheme.secondary,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            splashColor: colorScheme.surface.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.surface.withOpacity(0.15),
                    radius: 24.r,
                    child: Text(
                      surahNum,
                      style: TextStyle(
                        // fontFamily: "Lateef",
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // 🔹 Main info (Expanded avoids layout overflows)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Surah Arabic name (local font optimized)
                        Text(
                          "surah${surah.surahIndex.toString().padLeft(3, "0")}",
                          style: TextStyle(
                            fontFamily: "SurahName",
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 4.h),

                        // Ayah count + type
                        Row(
                          children: [
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "عدد اﻷيات: $ayahCount - ",
                                      style: TextStyle(
                                        fontFamily: "Lateef",
                                        fontSize: 16.sp,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            Icon(
                              isMakki
                                  ? FlutterIslamicIcons.kaaba
                                  : FlutterIslamicIcons.mosque,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 🔹 English Name
                  Text(
                    surah.surahNameTr,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 10.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

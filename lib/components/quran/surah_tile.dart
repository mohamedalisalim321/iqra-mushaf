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
    final colors = Theme.of(context).colorScheme;

    final surahNum = convertToArabicNumber(surah.surahIndex);
    final ayahCount = convertToArabicNumber(surah.versesCount);
    final isMakki = surah.surahType == "مكية";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Material(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(16.r),
        elevation: 3,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          splashColor: colors.primary.withOpacity(0.1),
          highlightColor: colors.primary.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: colors.surface.withOpacity(0.15),
                  radius: 26.r,
                  child: Text(
                    surahNum,
                    style: TextStyle(
                      fontSize: 22.sp,
<<<<<<< HEAD
                      fontWeight: FontWeight.w700,
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "surah${surah.surahIndex.toString().padLeft(3, '0')}",
                        style: TextStyle(
                          fontFamily: "SurahName",
                          fontSize: 22.sp,
                          color: Colors.white,
<<<<<<< HEAD
                          height: 1.1,
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
<<<<<<< HEAD
                          Expanded(
                            child: Text(
                              "عدد الآيات: $ayahCount",
                              style: TextStyle(
                                fontFamily: "Lateef",
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
=======
                          Text(
                            "الآيات $ayahCount - ",
                            style: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 16.sp,
                              color: Colors.white,
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                          Icon(
                            isMakki
                                ? FlutterIslamicIcons.kaaba
                                : FlutterIslamicIcons.mosque,
                            size: 18.sp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  surah.surahNameTr,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: 11.sp,
<<<<<<< HEAD
                    fontWeight: FontWeight.w500,
=======
>>>>>>> 21bed5c1ab6ee90d7b146acf907b11caaf65ae64
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

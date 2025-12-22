import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';
import '../../models/quran/surah.dart';

class SurahTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback? onTap;

  const SurahTile({
    super.key,
    required this.surah,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final String surahNum = surah.surahIndex.toArabicDigits();
    final String versesCount = surah.versesCount.toArabicDigits();
    final bool isMakki = surah.surahType == "مكية";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Material(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(16.r),
        elevation: 3,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            if (onTap != null) {
              Feedback.forTap(context);
              onTap!();
            }
          },
          splashColor: colors.primary.withOpacity(0.12),
          highlightColor: colors.primary.withOpacity(0.06),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSurahNumberBadge(surahNum, colors),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildSurahInfo(
                    'surah${surah.surahIndex.toString().padLeft(3, '0')}',
                    versesCount,
                    isMakki,
                    colors,
                  ),
                ),
                SizedBox(width: 12.w),
                _buildTranslation(surah.surahNameTr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahNumberBadge(String surahNum, ColorScheme colors) {
    return CircleAvatar(
      backgroundColor: colors.surface.withOpacity(0.15),
      radius: 26.r,
      child: Text(
        surahNum,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "Cairo",
        ),
      ),
    );
  }

  Widget _buildSurahInfo(
    String surahNameArabic,
    String versesCount,
    bool isMakki,
    ColorScheme colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          surahNameArabic,
          style: TextStyle(
            fontFamily: 'SurahName',
            fontSize: 24.sp,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الآيات $versesCount',
              style: TextStyle(
                fontFamily: 'Lateef',
                fontSize: 16.sp,
                color: Colors.white,
              ),
              overflow: TextOverflow.fade,
              maxLines: 1,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(width: 6.w),
            Icon(
              isMakki ? FlutterIslamicIcons.kaaba : FlutterIslamicIcons.mosque,
              size: 24.sp,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTranslation(String translation) {
    return Text(
      translation,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.end,
      style: TextStyle(
        fontFamily: "Lora",
        fontSize: 12.sp,
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

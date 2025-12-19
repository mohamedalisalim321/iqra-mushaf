import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

class QuranPageNumber extends StatelessWidget {
  final int pageNumber;

  const QuranPageNumber({
    super.key,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/quran page number.png",
            height: 75.h,
            width: 75.w,
            fit: BoxFit.fill,
          ),
          Text(
            pageNumber.toString().toArabicDigits(),
            style: TextStyle(
              fontFamily: "Kufi",
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

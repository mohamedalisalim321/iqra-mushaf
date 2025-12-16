import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class QuranPageNumber extends StatelessWidget {
  final int pageNumber;
  final void Function()? onTap;

  const QuranPageNumber({
    super.key,
    required this.pageNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/quran page number.png",
            height: 80,
            width: 80,
          ),
          Text(pageNumber.toString().toArabicDigits()),
        ],
      ),
    );
  }
}

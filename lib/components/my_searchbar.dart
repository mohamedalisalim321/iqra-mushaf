import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySearchbar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const MySearchbar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color textColor = colorScheme.onSurface;
    final Color hintColor = textColor.withOpacity(0.7);
    final EdgeInsets padding =
        EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.right,
      maxLines: 1,
      style: TextStyle(
        fontFamily: "Kufi",
        color: textColor,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child:
              Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        // suffixIcon: controller.text.isNotEmpty
        //     ? GestureDetector(
        //         onTap: () => controller.clear(),
        //         child: Icon(Icons.clear,
        //             color: colorScheme.onSurface.withOpacity(0.6)),
        //       )
        //     : null,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: "Kufi",
          color: hintColor,
          fontSize: 16.sp,
        ),
        contentPadding: padding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r), // More rounded corners
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: colorScheme.surface.withOpacity(0.05),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide(
            color: colorScheme.primary.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.2),
            width: 1.2,
          ),
        ),
        focusColor: colorScheme.primary.withOpacity(0.1),
      ),
    );
  }
}

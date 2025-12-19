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
        EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.right,
      maxLines: 1,
      style: TextStyle(
        fontFamily: "Kufi",
        color: textColor,
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: "Kufi",
          color: hintColor,
        ),
        contentPadding: padding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.2)),
        ),
        filled: true,
        fillColor: colorScheme.surface.withOpacity(0.05),
      ),
    );
  }
}

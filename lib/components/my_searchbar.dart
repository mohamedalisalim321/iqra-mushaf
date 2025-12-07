import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySearchbar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const MySearchbar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color textColor = colorScheme.onSurface;
    final Color hintColor = textColor.withOpacity(0.7);
    final EdgeInsets padding =
        EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h);

    return RepaintBoundary(
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: TextAlign.right,
        maxLines: 1,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.search),
            color: colorScheme.primary,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
          contentPadding: padding,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

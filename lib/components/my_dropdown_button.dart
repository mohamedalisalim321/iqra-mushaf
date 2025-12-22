import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDropdownButton<T> extends StatelessWidget {
  final T? selectedValue;
  final List<DropdownMenuItem<T>> dropdownItems;
  final ValueChanged<T?>? onChanged;

  const MyDropdownButton({
    super.key,
    required this.selectedValue,
    required this.dropdownItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(4.h),
      child: DropdownButton<T>(
        value: selectedValue,

        isExpanded: false, // Ensures the dropdown takes up all available width
        onChanged: onChanged,
        dropdownColor: Colors.white,
        underline: Container(), // Removes the underline for a clean look
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0.sp,
        ),

        items: dropdownItems,
      ),
    );
  }
}

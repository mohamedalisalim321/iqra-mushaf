import 'package:flutter/material.dart';

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
    return DropdownButton<T>(
      value: selectedValue,
      isExpanded: false, // Ensures the dropdown takes up all available width
      onChanged: onChanged,
      dropdownColor: Colors.white,
      underline: Container(), // Removes the underline for a clean look
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ), // Custom icon
      iconSize: 24.0, // Size of the icon
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
      items: dropdownItems,
    );
  }
}

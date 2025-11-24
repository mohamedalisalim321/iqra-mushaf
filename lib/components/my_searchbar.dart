import 'package:flutter/material.dart';

class MySearchbar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;

  final String hintText;

  const MySearchbar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      decoration: const InputDecoration(
        icon: Icon(Icons.search),
        hintText: "ابحث عن سورة",
        border: InputBorder.none,
      ),
    );
  }
}

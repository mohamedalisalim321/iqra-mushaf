import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySearchBar extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final String hintText;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final bool autofocus;
  final bool enableClearButton;
  final Duration debounceDuration;

  const MySearchBar({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    required this.hintText,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    this.backgroundColor,
    this.hintStyle,
    this.textStyle,
    this.autofocus = false,
    this.enableClearButton = true,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // update clear button visibility

    if (widget.onChanged != null) {
      _debounce?.cancel();
      _debounce = Timer(widget.debounceDuration, () {
        widget.onChanged?.call(_controller.text.trim());
      });
    }
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSubmitted?.call(text);
    _focusNode.unfocus();
  }

  void _clearText() {
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.cardColor;
    final iconColor = theme.iconTheme.color?.withOpacity(0.6) ?? Colors.grey;
    final hintStyle = widget.hintStyle ??
        TextStyle(color: theme.hintColor, fontSize: 15.sp, height: 1.2.h);
    final textStyle = widget.textStyle ?? theme.textTheme.bodyMedium;

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 22.h, color: iconColor),
          SizedBox(width: 10.h),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              autofocus: widget.autofocus,
              textInputAction: TextInputAction.search,
              style: textStyle,
              onSubmitted: (_) => _handleSubmit(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: hintStyle,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (widget.enableClearButton)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _controller.text.isNotEmpty
                  ? GestureDetector(
                      key: const ValueKey('clear'),
                      onTap: _clearText,
                      child: Icon(Icons.close, size: 20.sp, color: iconColor),
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
        ],
      ),
    );
  }
}

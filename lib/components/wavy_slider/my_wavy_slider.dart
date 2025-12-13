import 'package:flutter/material.dart';
import 'dart:math';

class MyWavySlider extends StatefulWidget {
  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final Color? inactiveColor;
  final Color? activeColor;
  final double? height;
  final double? waveAmplitude;
  final double? waveFrequency;

  const MyWavySlider({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
    this.inactiveColor,
    this.activeColor,
    this.height,
    this.waveAmplitude,
    this.waveFrequency,
  });

  @override
  State<MyWavySlider> createState() => _MyWavySliderState();
}

class _MyWavySliderState extends State<MyWavySlider> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.max == 0 ? 0 : widget.value / widget.max;
  }

  @override
  void didUpdateWidget(covariant MyWavySlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// When audio positionStream updates → reflect
    if (oldWidget.value != widget.value ||
        oldWidget.max != widget.max) {
      if (!isDragging) {
        _progress = widget.max == 0 ? 0 : widget.value / widget.max;
      }
    }
  }

  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      /// Start Dragging
      onHorizontalDragStart: (_) {
        isDragging = true;
      },

      /// Drag Update
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final localX = box.globalToLocal(details.globalPosition).dx;
        final width = box.size.width;

        double percent = (localX / width).clamp(0.0, 1.0);

        setState(() {
          _progress = percent; // UPDATE UI IMMEDIATELY
        });

        widget.onChanged(percent * widget.max);
      },

      /// Drag End → allow external updates again
      onHorizontalDragEnd: (_) {
        isDragging = false;
      },

      child: SizedBox(
        height: widget.height ?? 40,
        child: CustomPaint(
          painter: MyWavySliderPainter(
            progress: _progress,
            inactiveColor: widget.inactiveColor ?? Colors.grey.withOpacity(0.4),
            activeColor: widget.activeColor ?? Colors.green,
            amplitude: widget.waveAmplitude ?? 6.0,
            frequency: widget.waveFrequency ?? 30.0,
          ),
        ),
      ),
    );
  }
}

class MyWavySliderPainter extends CustomPainter {
  final double progress;
  final Color inactiveColor;
  final Color activeColor;
  final double amplitude;
  final double frequency;

  MyWavySliderPainter({
    required this.progress,
    required this.inactiveColor,
    required this.activeColor,
    required this.amplitude,
    required this.frequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fullPath = _generateWavePath(size, 1.0);
    final progressPath = _generateWavePath(size, progress);

    canvas.drawPath(fullPath, paint..color = inactiveColor);
    canvas.drawPath(progressPath, paint..color = activeColor);

    // Thumb
    if (progress > 0) {
      final x = size.width * progress;
      final y = size.height / 2 +
          sin((x / frequency) * 2 * pi) * amplitude;

      canvas.drawCircle(Offset(x, y), 6, Paint()..color = activeColor);
    }
  }

  Path _generateWavePath(Size size, double factor) {
    final path = Path();
    final maxX = size.width * factor;

    if (maxX <= 0) return path;

    for (double x = 0; x <= maxX; x++) {
      final y = size.height / 2 +
          sin((x / frequency) * 2 * pi) * amplitude;

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant MyWavySliderPainter old) {
    return old.progress != progress ||
        old.inactiveColor != inactiveColor ||
        old.activeColor != activeColor ||
        old.amplitude != amplitude ||
        old.frequency != frequency;
  }
}

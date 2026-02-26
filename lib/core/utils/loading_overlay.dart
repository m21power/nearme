import 'package:flutter/material.dart';
import 'dart:ui';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Blurred background overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            color: (isDark ? Colors.black : Colors.white).withOpacity(0.3),
          ),
        ),

        // Center Loader
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _PulseDot(delay: 0.0),
              SizedBox(width: 8),
              _PulseDot(delay: 0.2),
              SizedBox(width: 8),
              _PulseDot(delay: 0.4),
            ],
          ),
        ),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  final double delay;
  const _PulseDot({required this.delay, Key? key}) : super(key: key);

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  double _applyPhaseShift(double value, double phase) {
    return (value + phase) % 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dotColor = isDark ? Colors.white : Colors.black;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final phasedValue = _applyPhaseShift(_controller.value, widget.delay);
        final scale = 0.5 + 0.7 * phasedValue; // Maps 0.0→0.5, 1.0→1.2
        final opacity = 0.3 + 0.7 * phasedValue; // Maps 0.0→0.3, 1.0→1.0

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: CircleAvatar(radius: 6, backgroundColor: dotColor),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

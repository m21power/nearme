import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/entities/post_model.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({super.key, required this.stories});

  final List<StoryModel> stories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const MyStoryAvatar();
          }

          final story = stories[index - 1];

          return StoryAvatar(story: story);
        },
      ),
    );
  }
}

class StoryAvatar extends StatelessWidget {
  final StoryModel story;
  const StoryAvatar({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool isSeen = story.isSeen;

    return Column(
      children: [
        Container(
          width: 64, // ← fixed outer size
          height: 64,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: !isSeen
                ? LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  )
                : null,
            border: isSeen
                ? Border.all(color: colorScheme.outlineVariant, width: 2)
                : null,
          ),
          child: CircleAvatar(
            radius: 28, // stays 28
            backgroundImage: AssetImage(story.imageUrl),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Text(
            story.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class MyStoryAvatar extends StatelessWidget {
  const MyStoryAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          width: 64, // ← same outer size as others
          height: 64,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              DashedCircle(
                size: 64, // reduced from 70
                color: scheme.primary,
                strokeWidth: 3,
                dash: 8,
                gap: 6,
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: scheme.surface,
                child: Icon(Icons.add, color: scheme.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Text(
            "My Story",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class DashedCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;

  const DashedCircle({
    super.key,
    required this.size,
    required this.color,
    this.strokeWidth = 3,
    this.dash = 6,
    this.gap = 6,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCirclePainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dash,
        gapLength: gap,
      ),
      size: Size(size, size),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = size.width / 2;
    final angle = 2 * pi;
    final circumference = angle * radius;

    final dashCount = circumference ~/ (dashLength + gapLength);
    final dashAngle = angle / dashCount;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        dashAngle * (dashLength / (dashLength + gapLength)),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

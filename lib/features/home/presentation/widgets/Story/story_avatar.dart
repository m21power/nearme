import 'package:flutter/material.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';

import '../../../../../core/utils/dashed_circle.dart';

class StoryAvatar extends StatelessWidget {
  final StoryModel story;
  const StoryAvatar({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Container(
          width: 64, // ← fixed outer size
          height: 64,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: !story.isSeen
                ? LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  )
                : null,
            border: story.isSeen
                ? Border.all(color: colorScheme.outlineVariant, width: 2)
                : null,
          ),
          child: CircleAvatar(
            radius: 28, // stays 28
            backgroundImage: NetworkImage(story.authorUrl),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Text(
            story.authorName,
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
  final StoryModel? story;
  const MyStoryAvatar({super.key, this.story});

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
                backgroundImage: story != null && story!.authorUrl.isNotEmpty
                    ? NetworkImage(story!.authorUrl)
                    : null,
                child: story == null
                    ? Icon(Icons.add, color: scheme.primary)
                    : null,
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

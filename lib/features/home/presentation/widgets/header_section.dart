import 'package:flutter/material.dart';
import 'package:nearme/features/home/presentation/widgets/header_icon_button.dart';

import '../../domain/entities/post_model.dart';
import 'story_avatar.dart';

class HeaderSection extends StatelessWidget {
  HeaderSection();
  final stories = [
    StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
    StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
    StoryModel(
      name: "Design Club",
      imageUrl: "assets/image.jpg",
      isSeen: false,
    ),
    StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
    StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
    StoryModel(
      name: "Design Club",
      imageUrl: "assets/image.jpg",
      isSeen: false,
    ),
    StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
    StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
    StoryModel(
      name: "Design Club",
      imageUrl: "assets/image.jpg",
      isSeen: false,
    ),
    StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
    StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
    StoryModel(
      name: "Design Club",
      imageUrl: "assets/image.jpg",
      isSeen: false,
    ),
    StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
    StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
    StoryModel(
      name: "Design Club",
      imageUrl: "assets/image.jpg",
      isSeen: false,
    ),
    StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
    StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
    StoryModel(
      name: "Design Club",
      imageUrl: "assets/image.jpg",
      isSeen: false,
    ),
    StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
    StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
    StoryModel(
      name: "Design Club",
      imageUrl: "assets/image.jpg",
      isSeen: false,
    ),
    StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
    StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
    StoryModel(
      name: "Design Club",
      imageUrl: "assets/image.jpg",
      isSeen: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TOP ROW
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Near Me",
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("IN CAMPUS", style: textTheme.bodySmall),
                ],
              ),
            ),

            /// Person Add Button
            HeaderIconButton(icon: Icons.person_add_alt_1, onTap: () {}),

            const SizedBox(width: 12),

            /// Notification Button
            HeaderIconButton(
              icon: Icons.notifications_none,
              showDot: true,
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 20),
        StoryWidget(stories: stories),
      ],
    );
  }
}

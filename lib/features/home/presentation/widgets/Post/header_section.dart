import 'package:flutter/material.dart';
import 'package:nearme/features/home/presentation/StoryBlock/story_bloc.dart';
import 'package:nearme/features/home/presentation/widgets/Post/header_icon_button.dart';

import '../Story/story_widget.dart';

class HeaderSection extends StatelessWidget {
  final StoryState storyState;
  HeaderSection({super.key, required this.storyState});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    print("Building HeaderSection with storyState: ${storyState.stories}");
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
        StoryWidget(storyState: storyState),
      ],
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/constant/pick_image.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/features/home/presentation/widgets/Story/story_avatar.dart';

import '../../StoryBlock/story_bloc.dart';
import '../../pages/Story/create_story_screen.dart';
import '../../pages/Story/story_viewer.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({super.key, required this.storyState});

  final StoryState storyState;

  @override
  Widget build(BuildContext context) {
    print("Building StoryWidget with stories: ${storyState.stories}");
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: storyState.stories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          /// ✅ INDEX 0 — My Story / Add Story
          if (index == 0) {
            final myStory = storyState.stories
                .where((s) => s.authorId == UserSession.instance.userId)
                .toList();

            // User already has a story
            if (myStory.isNotEmpty) {
              final story = myStory.first;

              return GestureDetector(
                onTap: () {
                  if (!story.isSeen) {
                    context.read<StoryBloc>().add(
                      ViewStoryEvent(storyId: story.storyId),
                    );
                  }

                  context.read<StoryBloc>().add(
                    FetchViewerEvent(storyId: story.storyId),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryViewer(story: story, isAuthor: true),
                    ),
                  );
                },
                child: MyStoryAvatar(story: story),
              );
            }

            // No story → add button
            return GestureDetector(
              onTap: () async {
                File? image = await pickAndConfirmImage(context, "Story");
                if (image != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateStoryScreen(image: image),
                    ),
                  );
                }
              },
              child: const MyStoryAvatar(),
            );
          }

          /// ✅ INDEX > 0 — Other users' stories
          final story = storyState.stories[index - 1];

          // Skip your own story (already shown at index 0)
          if (story.authorId == UserSession.instance.userId) {
            return const SizedBox.shrink();
          }

          return GestureDetector(
            onTap: () {
              if (!story.isSeen) {
                context.read<StoryBloc>().add(
                  ViewStoryEvent(storyId: story.storyId),
                );
              }

              context.read<StoryBloc>().add(
                FetchViewerEvent(storyId: story.storyId),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryViewer(story: story, isAuthor: false),
                ),
              );
            },
            child: StoryAvatar(story: story),
          );
        },
      ),
    );
  }
}

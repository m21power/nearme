import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/utils/loading_overlay.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';
import 'package:nearme/features/home/presentation/StoryBlock/story_bloc.dart';

import '../widgets/Post/header_section.dart';
import '../widgets/Post/post_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, homeState) {
        // TODO: implement listener
      },
      builder: (context, homeState) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(FetchPostsEvent());
            context.read<StoryBloc>().add(FetchStoriesEvent());
          },
          child: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  /// MAIN CONTENT
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      BlocBuilder<StoryBloc, StoryState>(
                        builder: (context, storyState) {
                          print("Story State in Home Page: $storyState");
                          return HeaderSection(storyState: storyState);
                        },
                      ),
                      const SizedBox(height: 24),

                      if (homeState.posts.isNotEmpty)
                        ...homeState.posts.map(
                          (post) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: PostCard(post: post, isDetailPage: false),
                          ),
                        ),
                    ],
                  ),

                  /// EMPTY STATE (Centered)
                  if (homeState.posts.isEmpty &&
                      homeState is! FetchPostsLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "No posts yet.\nBe the first to share something with your campus!",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  /// LOADING OVERLAY (Centered Circular Progress)
                  if (homeState is FetchPostsLoading) LoadingOverlay(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

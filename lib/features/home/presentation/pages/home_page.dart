import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/utils/loading_overlay.dart';
import 'package:nearme/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';
import 'package:nearme/features/home/presentation/StoryBlock/story_bloc.dart';

import '../widgets/Post/header_section.dart';
import '../widgets/Post/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(UpdateStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, homeState) {
        print(
          "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^",
        );
        print("Home State Updated: $homeState");
      },
      builder: (context, homeState) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(FetchPostsEvent());
            context.read<StoryBloc>().add(FetchStoriesEvent());
            context.read<ChatBloc>().add(UpdateStatusEvent());
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

                  /// LOADING OVERLAY (Centered Circular Progress)
                  if (homeState is FetchPostsLoading ||
                      homeState is FetchMyPostsLoading)
                    LoadingOverlay(),

                  /// EMPTY STATE (Centered)
                  if (homeState.posts.isEmpty &&
                      homeState is! FetchPostsLoading)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child:
                            (homeState is FetchPostsLoading ||
                                homeState is FetchMyPostsLoading)
                            ? Text("Fetching . . .")
                            : Text(
                                "No posts yet.\nBe the first to share something with your campus!",
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

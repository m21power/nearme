import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/features/home/presentation/StoryBlock/story_bloc.dart';
import 'package:nearme/features/home/presentation/widgets/Post/delete_dialog.dart';
import 'package:nearme/features/home/presentation/widgets/Story/story_viewer_sheet.dart';
import 'package:shimmer/shimmer.dart';

import '../../../domain/entities/post_model.dart';

class StoryViewer extends StatefulWidget {
  final bool isAuthor;
  final StoryModel story;

  const StoryViewer({super.key, required this.story, required this.isAuthor});

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  bool isLiked = false;
  bool isLoading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SafeArea(
      child: BlocConsumer<StoryBloc, StoryState>(
        listener: (context, storyState) {
          StoryModel? newStory;
          for (var s in storyState.stories) {
            if (s.storyId == widget.story.storyId) {
              newStory = s;
              break;
            }
          }
          if (newStory != null) {
            setState(() {
              isLiked = newStory!.isLiked;
            });
          }
        },
        builder: (context, storyState) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: Stack(
              children: [
                /// Story Image + Shimmer
                Center(
                  child: isLoading
                      ? Shimmer.fromColors(
                          baseColor: colorScheme.surface,
                          highlightColor: colorScheme.surface.withOpacity(0.7),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: colorScheme.surface,
                          ),
                        )
                      : Image.network(
                          widget.story.mediaUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                ),

                /// Top Bar
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: colorScheme.onSurface),
                      ),

                      Text(
                        widget.story.authorName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 24),

                      /// Delete Button
                      if (UserSession.instance.userId ==
                              widget.story.authorId ||
                          UserSession.instance.userId ==
                              dotenv.env['ADMIN_USERID'])
                        GestureDetector(
                          onTap: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) =>
                                  const DeleteDialog(content: "Story"),
                            );

                            if (shouldDelete == true) {
                              context.read<StoryBloc>().add(
                                DeleteStoryEvent(storyId: widget.story.storyId),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Icon(Icons.delete, color: colorScheme.error),
                        ),
                    ],
                  ),
                ),

                /// Bottom Section
                Positioned(
                  bottom: 30,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Viewers count
                      widget.isAuthor
                          ? GestureDetector(
                              onTap: () => showViewersSheet(
                                context,
                                storyState.viewers[widget.story.storyId] ?? [],
                                widget.story.likeCount,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 12,
                                ),
                                child: Text(
                                  '👀 ${widget.story.viewerCount} viewers',
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),

                      /// Caption
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.story.caption ?? '',
                          style: textTheme.bodyLarge,
                        ),
                      ),

                      Row(
                        children: [
                          /// Input Field
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  // Expanded(
                                  //   child: TextField(
                                  //     controller: _controller,
                                  //     style: textTheme.bodyLarge,
                                  //     decoration: InputDecoration(
                                  //       hintText: 'Add a comment...',
                                  //       border: InputBorder.none,
                                  //     ),
                                  //     onChanged: (_) => setState(() {}),
                                  //   ),
                                  // ),
                                  if (_controller.text.isNotEmpty)
                                    IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        color: colorScheme.primary,
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor:
                                                colorScheme.surface,
                                            content: Text(
                                              'Comment: ${_controller.text}',
                                              style: textTheme.bodyMedium,
                                            ),
                                          ),
                                        );
                                        _controller.clear();
                                        setState(() {});
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// Like Button
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked
                                  ? Colors.red
                                  : colorScheme.onSurface,
                              size: 32,
                            ),
                            onPressed: () {
                              context.read<StoryBloc>().add(
                                LikeStoryEvent(storyId: widget.story.storyId),
                              );
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Simulate image loading
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
}

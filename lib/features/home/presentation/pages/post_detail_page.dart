import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/utils/normalize_time.dart';
import 'package:nearme/features/home/domain/entities/comment_model.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/presentation/bloc/home_bloc.dart';
import 'package:nearme/features/home/presentation/widgets/comment_input.dart';
import 'package:nearme/features/home/presentation/widgets/comment_tile.dart';
import 'package:nearme/features/home/presentation/widgets/post_card.dart';

class PostDetailPage extends StatefulWidget {
  PostModel post;

  PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Map<String, List<CommentModel>> commentList = {};

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, homeState) {
        // TODO: implement listener
        if (homeState is FetchCommentsState) {
          setState(() {
            commentList = homeState.commentsByPost;
            widget.post = homeState.posts.firstWhere(
              (p) => p.postId == widget.post.postId,
            );
          });
        }
      },
      builder: (context, homeState) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(
              FetchCommentsEvent(postId: widget.post.postId),
            );
          },
          child: Scaffold(
            appBar: AppBar(title: const Text("Post Details")),
            body: Column(
              children: [
                /// SCROLLABLE AREA
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      PostCard(post: widget.post, isDetailPage: true),

                      const SizedBox(height: 24),

                      Text(
                        "Comments",
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...?commentList[widget.post.postId]?.map(
                            (comment) => CommentTile(
                              comment: comment,
                              onDelete: (String commentId) {
                                context.read<HomeBloc>().add(
                                  DeleteCommentEvent(commentId: commentId),
                                );
                                commentList[widget.post.postId] =
                                    commentList[widget.post.postId]!
                                        .where((c) => c.id != commentId)
                                        .toList();
                                setState(() {});
                              },
                            ),
                          ) ??
                          [],
                    ],
                  ),
                ),

                /// COMMENT INPUT
                // _buildCommentInput(context),
                SafeArea(
                  child: buildCommentInput(context, widget.post, (
                    String comment,
                  ) {
                    context.read<HomeBloc>().add(
                      CommentOnPostEvent(
                        postId: widget.post.postId,
                        comment: comment,
                      ),
                    );
                    context.read<HomeBloc>().add(FetchPostsEvent());
                    setState(() {
                      commentList[widget.post.postId] = [
                        CommentModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          userId: UserSession.instance.userId!,
                          userName: UserSession.instance.name!,
                          imageUrl: UserSession.instance.profileImage,
                          dept: UserSession.instance.dept ?? "---",
                          comment: comment,
                          createdAt: DateTime.now().toIso8601String(),
                        ),
                        ...(commentList[widget.post.postId] ?? []),
                      ];
                    });
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

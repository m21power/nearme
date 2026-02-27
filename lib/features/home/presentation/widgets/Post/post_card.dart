import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:nearme/core/constant/route_constant.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';
import 'package:nearme/features/home/presentation/widgets/Post/delete_dialog.dart';

import '../../../../../core/utils/normalize_time.dart';
import '../../../domain/entities/post_model.dart';
import '../../pages/post_detail_page.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isDetailPage;

  const PostCard({super.key, required this.post, required this.isDetailPage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER HEADER
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: colorScheme.surface,
                  foregroundImage:
                      UserSession.instance.profileImage != null &&
                          UserSession.instance.profileImage!.isNotEmpty
                      ? NetworkImage(UserSession.instance.profileImage!)
                      : null,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${post.dept} · ${formatTimeAgo(post.createdAt)}",
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                ((UserSession.instance.userId == post.userId ||
                            UserSession.instance.userId ==
                                dotenv.env['ADMIN_USERID']) &&
                        isDetailPage)
                    ? GestureDetector(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) =>
                                const DeleteDialog(content: "Post"),
                          );

                          if (shouldDelete == true) {
                            context.read<HomeBloc>().add(
                              DeletePostEvent(postId: post.postId),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Icon(Icons.delete, color: colorScheme.error),
                      )
                    : SizedBox.shrink(),
              ],
            ),

            const SizedBox(height: 16),

            /// IMAGE (if exists)
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(post.imageUrl!, fit: BoxFit.cover),
              ),

            if (post.imageUrl != null) const SizedBox(height: 16),

            /// CAPTION (if exists)
            if (post.caption != null)
              Text(post.caption!, style: textTheme.bodyMedium),

            const SizedBox(height: 16),

            /// LIKE / COMMENT
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<HomeBloc>().add(
                      LikePostEvent(postId: post.postId),
                    );
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(post.isLiked),
                      color: post.isLiked ? Colors.red : colorScheme.onSurface,
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    "${post.likes}",
                    key: ValueKey(post.likes),
                    style: textTheme.bodyMedium,
                  ),
                ),

                const SizedBox(width: 24),

                // Icon(Icons.chat_bubble_outline, color: colorScheme.onSurface),
                // const SizedBox(width: 6),
                // Text("${post.comments}", style: textTheme.bodyMedium),
                GestureDetector(
                  onTap: () {
                    context.read<HomeBloc>().add(
                      FetchCommentsEvent(postId: post.postId),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PostDetailPage(post: post),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(width: 6),
                      Text("${post.comments}", style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

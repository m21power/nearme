import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/utils/normalize_time.dart';
import 'package:nearme/features/home/domain/entities/comment_model.dart';
import 'package:nearme/features/home/presentation/widgets/Post/delete_dialog.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final Function(String) onDelete;

  const CommentTile({super.key, required this.comment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER HEADER (same as PostCard)
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: colorScheme.surface,
                  foregroundImage:
                      comment.imageUrl != null && comment.imageUrl!.isNotEmpty
                      ? NetworkImage(comment.imageUrl!)
                      : null,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${comment.dept ?? "---"} · ${formatTimeAgo(comment.createdAt!)}",
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                (comment.userId == UserSession.instance.userId ||
                        UserSession.instance.userId ==
                            dotenv.env['ADMIN_USERID'])
                    ? Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) =>
                                  const DeleteDialog(content: "Comment"),
                            );

                            if (shouldDelete == true) {
                              onDelete(comment.id!);
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: 8),
            Text(comment.comment, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

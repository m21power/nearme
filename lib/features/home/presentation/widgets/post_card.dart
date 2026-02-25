import 'package:flutter/material.dart';

import '../../domain/entities/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

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
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/image.jpg"),
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
                        "${post.department} · ${post.timeAgo}",
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: colorScheme.onSurface),
              ],
            ),

            const SizedBox(height: 16),

            /// IMAGE (if exists)
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(post.imageUrl!, fit: BoxFit.cover),
              ),

            if (post.imageUrl != null) const SizedBox(height: 16),

            /// CAPTION (if exists)
            if (post.caption != null)
              Text(post.caption!, style: textTheme.bodyMedium),

            const SizedBox(height: 16),

            /// LIKE / COMMENT
            Row(
              children: [
                Icon(Icons.favorite_border, color: colorScheme.onSurface),
                const SizedBox(width: 6),
                Text("${post.likes}", style: textTheme.bodyMedium),
                const SizedBox(width: 24),
                Icon(Icons.chat_bubble_outline, color: colorScheme.onSurface),
                const SizedBox(width: 6),
                Text("${post.comments}", style: textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

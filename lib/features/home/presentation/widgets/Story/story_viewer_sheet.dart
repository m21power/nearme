import 'package:flutter/material.dart';
import 'package:nearme/core/utils/normalize_time.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';

void showViewersSheet(
  BuildContext context,
  List<ViewerModel> viewers,
  int likeCount,
) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;
  final textTheme = theme.textTheme;

  showModalBottomSheet(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Story Interactions',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '❤️ $likeCount likes',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// ❤️ Liked viewers
          ...viewers
              .where((viewer) => viewer.isLiked)
              .map(
                (viewer) => ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: colors.primary,
                    foregroundImage: NetworkImage(viewer.viewerProfileUrl),
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: colors.onPrimary,
                    ),
                  ),
                  title: Text(viewer.viewerName, style: textTheme.bodyLarge),
                  subtitle: Text(
                    formatTimeAgo(viewer.seenAt),
                    style: textTheme.bodyMedium,
                  ),
                  trailing: Icon(Icons.favorite, size: 16, color: Colors.red),
                ),
              ),
          ...viewers
              .where((viewer) => !viewer.isLiked)
              .map(
                (viewer) => ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: colors.primary,
                    foregroundImage: NetworkImage(viewer.viewerProfileUrl),

                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: colors.onPrimary,
                    ),
                  ),
                  title: Text(viewer.viewerName, style: textTheme.bodyLarge),
                  subtitle: Text(
                    formatTimeAgo(viewer.seenAt),
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}

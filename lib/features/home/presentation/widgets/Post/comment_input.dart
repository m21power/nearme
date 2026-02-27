import 'package:flutter/material.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';

Widget buildCommentInput(
  BuildContext context,
  PostModel post,
  Function? onCommentAdded,
) {
  final colorScheme = Theme.of(context).colorScheme;
  TextEditingController commentController = TextEditingController();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          /// USER AVATAR
          CircleAvatar(
            radius: 18,
            backgroundColor: colorScheme.background,
            foregroundImage:
                UserSession.instance.profileImage != null &&
                    UserSession.instance.profileImage!.isNotEmpty
                ? NetworkImage(UserSession.instance.profileImage!)
                : null,
            child: Icon(Icons.person, color: colorScheme.primary),
          ),

          const SizedBox(width: 12),

          /// TEXT FIELD
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: "Write a comment...",
                border: InputBorder.none,
              ),
            ),
          ),

          /// SEND BUTTON
          IconButton(
            icon: Icon(Icons.send, color: colorScheme.primary),
            onPressed: () {
              if (commentController.text.trim().isEmpty) return;
              if (onCommentAdded != null) {
                onCommentAdded(commentController.text.trim());
              }

              commentController.clear();
            },
          ),
        ],
      ),
    ),
  );
}

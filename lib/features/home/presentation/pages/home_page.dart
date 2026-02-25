import 'package:flutter/material.dart';

import '../../domain/entities/post_model.dart';
import '../widgets/header_section.dart';
import '../widgets/post_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final posts = [
      PostModel(
        userName: "Sarah Jenkins",
        department: "Computer Science Dept.",
        timeAgo: "2h ago",
        caption:
            "Finally finished our group project for CS101! So proud of the team 🚀",
        imageUrl: "assets/image.jpg",
        likes: 124,
        comments: 12,
      ),
      PostModel(
        userName: "Mike T.",
        department: "Design Club",
        timeAgo: "5h ago",
        caption: "Design sprint went amazing today!",
        imageUrl: null,
        likes: 45,
        comments: 6,
      ),
      PostModel(
        userName: "Sarah J.",
        department: "Math Club",
        timeAgo: "1d ago",
        caption: null,
        imageUrl: "assets/image.jpg",
        likes: 78,
        comments: 9,
      ),
      PostModel(
        userName: "Sarah Jenkins",
        department: "Computer Science Dept.",
        timeAgo: "2h ago",
        caption:
            "Finally finished our group project for CS101! So proud of the team 🚀",
        imageUrl: "assets/image.jpg",
        likes: 124,
        comments: 12,
      ),
      PostModel(
        userName: "Mike T.",
        department: "Design Club",
        timeAgo: "5h ago",
        caption: "Design sprint went amazing today!",
        imageUrl: null,
        likes: 45,
        comments: 6,
      ),
      PostModel(
        userName: "Sarah J.",
        department: "Math Club",
        timeAgo: "1d ago",
        caption: null,
        imageUrl: "assets/image.jpg",
        likes: 78,
        comments: 9,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HeaderSection(),
            const SizedBox(height: 24),
            ...posts.map(
              (post) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PostCard(post: post),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

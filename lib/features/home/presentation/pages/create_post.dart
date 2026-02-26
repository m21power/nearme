import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _captionController = TextEditingController();

  bool hasImage = true; // simulate image selection

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool canPost = _captionController.text.isNotEmpty || hasImage;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Post",
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: canPost ? () {} : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Post"),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// IMAGE PREVIEW (optional)
            if (hasImage)
              Stack(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: colors.surface,
                    ),
                    child: const Icon(Icons.image, size: 80),
                  ),

                  /// Edit Image Button
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surface.withOpacity(.9),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),

            if (hasImage) const SizedBox(height: 20),

            /// CAPTION INPUT
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: colors.surface,
                    // child: Icon(Icons.person, color: colors.primary),
                    backgroundImage: const AssetImage("assets/image.jpg"),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: TextField(
                      controller: _captionController,
                      maxLines: null,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: "What's happening on campus?",
                        border: InputBorder.none,
                      ),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

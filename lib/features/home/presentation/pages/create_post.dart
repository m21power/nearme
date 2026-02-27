import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nearme/core/constant/pick_image.dart';
import 'package:nearme/core/constant/route_constant.dart';
import 'package:nearme/core/utils/loading_overlay.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';

import '../../../../core/constant/user_session.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _captionController = TextEditingController();

  bool hasImage = true; // simulate image selection
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool canPost = _captionController.text.isNotEmpty || hasImage;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, homeState) {
        if (homeState is PostCreatedState) {
          context.pushNamed(RouteConstant.mainNavigation);
        }
      },
      builder: (context, homeState) {
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
                  onPressed: canPost
                      ? () {
                          context.read<HomeBloc>().add(
                            CreatePostEvent(
                              caption: _captionController.text,
                              imagePath: imagePath,
                            ),
                          );
                        }
                      : null,
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

          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// IMAGE PREVIEW (optional)
                    if (hasImage)
                      Stack(
                        children: [
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: colors.surface,
                            ),
                            child: imagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(imagePath!),
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : const Icon(Icons.image, size: 80),
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
                              child: GestureDetector(
                                onTap: () async {
                                  File? image = await pickAndConfirmImage(
                                    context,
                                    "post",
                                  );
                                  setState(() {
                                    if (image != null) {
                                      imagePath = image.path;
                                      hasImage = true;
                                    } else {
                                      hasImage = false;
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: colors.onSurface,
                                ),
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
                            foregroundImage:
                                UserSession.instance.profileImage != null &&
                                    UserSession
                                        .instance
                                        .profileImage!
                                        .isNotEmpty
                                ? NetworkImage(
                                    UserSession.instance.profileImage!,
                                  )
                                : null,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: colors.primary,
                            ),
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
              if (homeState is CreatePostLoading) LoadingOverlay(),
            ],
          ),
        );
      },
    );
  }
}

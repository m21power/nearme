import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';

import '../../StoryBlock/story_bloc.dart';

class CreateStoryScreen extends StatefulWidget {
  final File image;

  const CreateStoryScreen({super.key, required this.image});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool isPosting = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: BlocConsumer<StoryBloc, StoryState>(
        listener: (context, storyState) {
          if (storyState is CreateStoryInProgress) {
            setState(() {
              isPosting = true;
            });
          } else {
            setState(() {
              isPosting = false;
            });
          }
          if (storyState is StoryCreated) {
            if (mounted) {
              Navigator.pop(context);
            }
          }
        },
        builder: (context, storyState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                /// 📸 Fullscreen Image Preview
                Positioned.fill(
                  child: Image.file(widget.image, fit: BoxFit.contain),
                ),

                Positioned(
                  top: 40,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 30,
                  left: 16,
                  right: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Caption Field
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _captionController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// Post Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: scheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: isPosting
                              ? null
                              : () {
                                  context.read<StoryBloc>().add(
                                    CreateStoryEvent(
                                      imagePath: widget.image.path,
                                      caption: _captionController.text.trim(),
                                    ),
                                  );
                                },
                          child: isPosting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Post Story",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
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
}

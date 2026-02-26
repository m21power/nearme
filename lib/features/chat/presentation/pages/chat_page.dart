import 'package:flutter/material.dart';
import 'package:nearme/features/home/presentation/widgets/story_avatar.dart';

import '../../../home/domain/entities/post_model.dart';
import '../widgets/chat_tile.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final stories = [
      StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
      StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
      StoryModel(
        name: "Design Club",
        imageUrl: "assets/image.jpg",
        isSeen: false,
      ),
      StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
      StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
      StoryModel(
        name: "Design Club",
        imageUrl: "assets/image.jpg",
        isSeen: false,
      ),
      StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
      StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
      StoryModel(
        name: "Design Club",
        imageUrl: "assets/image.jpg",
        isSeen: false,
      ),
      StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
      StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
      StoryModel(
        name: "Design Club",
        imageUrl: "assets/image.jpg",
        isSeen: false,
      ),
      StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
      StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
      StoryModel(
        name: "Design Club",
        imageUrl: "assets/image.jpg",
        isSeen: false,
      ),
      StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
      StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
      StoryModel(
        name: "Design Club",
        imageUrl: "assets/image.jpg",
        isSeen: false,
      ),
      StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
      StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
      StoryModel(
        name: "Design Club",
        imageUrl: "assets/image.jpg",
        isSeen: false,
      ),
      StoryModel(name: "Sarah J.", imageUrl: "assets/image.jpg", isSeen: false),
      StoryModel(name: "Mike T.", imageUrl: "assets/image.jpg", isSeen: true),
      StoryModel(
        name: "Design Club",
        imageUrl: "assets/image.jpg",
        isSeen: false,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Messages", style: theme.textTheme.headlineLarge),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_square,
                      color: colors.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// SEARCH
              TextField(
                decoration: const InputDecoration(
                  hintText: "Search messages...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 20),

              /// STORIES ROW
              StoryWidget(stories: stories),

              const SizedBox(height: 10),

              /// CHAT LIST
              Expanded(
                child: ListView(
                  children: const [
                    ChatTile(
                      name: "Jessica M.",
                      message: "Are you going to the mixer tonight?",
                      time: "10:42 AM",
                      unreadCount: 2,
                      isOnline: true,
                    ),
                    ChatTile(
                      name: "Study Group 101",
                      message: "David: I shared the notes in the drive.",
                      time: "Yesterday",
                    ),
                    ChatTile(
                      name: "Alex Chen",
                      message: "Can you send me the prof's email?",
                      time: "Tue",
                      isSent: true,
                    ),
                    ChatTile(
                      name: "Sarah W.",
                      message: "Thanks for the help!",
                      time: "Mon",
                      isSent: true,
                    ),
                    ChatTile(
                      name: "Football Club",
                      message: "Practice moved to 5 PM.",
                      time: "Sun",
                    ),
                    ChatTile(
                      name: "Mark",
                      message: "Let's catch up soon.",
                      time: "Last week",
                    ),
                    ChatTile(
                      name: "Emily",
                      message: "Is the library open late today?",
                      time: "Last week",
                    ),
                    ChatTile(
                      name: "Jessica M.",
                      message: "Are you going to the mixer tonight?",
                      time: "10:42 AM",
                      unreadCount: 2,
                      isOnline: true,
                    ),
                    ChatTile(
                      name: "Study Group 101",
                      message: "David: I shared the notes in the drive.",
                      time: "Yesterday",
                    ),
                    ChatTile(
                      name: "Alex Chen",
                      message: "Can you send me the prof's email?",
                      time: "Tue",
                      isSent: true,
                    ),
                    ChatTile(
                      name: "Sarah W.",
                      message: "Thanks for the help!",
                      time: "Mon",
                      isSent: true,
                    ),
                    ChatTile(
                      name: "Football Club",
                      message: "Practice moved to 5 PM.",
                      time: "Sun",
                    ),
                    ChatTile(
                      name: "Mark",
                      message: "Let's catch up soon.",
                      time: "Last week",
                    ),
                    ChatTile(
                      name: "Emily",
                      message: "Is the library open late today?",
                      time: "Last week",
                    ),
                    ChatTile(
                      name: "Jessica M.",
                      message: "Are you going to the mixer tonight?",
                      time: "10:42 AM",
                      unreadCount: 2,
                      isOnline: true,
                    ),
                    ChatTile(
                      name: "Study Group 101",
                      message: "David: I shared the notes in the drive.",
                      time: "Yesterday",
                    ),
                    ChatTile(
                      name: "Alex Chen",
                      message: "Can you send me the prof's email?",
                      time: "Tue",
                      isSent: true,
                    ),
                    ChatTile(
                      name: "Sarah W.",
                      message: "Thanks for the help!",
                      time: "Mon",
                      isSent: true,
                    ),
                    ChatTile(
                      name: "Football Club",
                      message: "Practice moved to 5 PM.",
                      time: "Sun",
                    ),
                    ChatTile(
                      name: "Mark",
                      message: "Let's catch up soon.",
                      time: "Last week",
                    ),
                    ChatTile(
                      name: "Emily",
                      message: "Is the library open late today?",
                      time: "Last week",
                    ),
                    ChatTile(
                      name: "Jessica M.",
                      message: "Are you going to the mixer tonight?",
                      time: "10:42 AM",
                      unreadCount: 2,
                      isOnline: true,
                    ),
                    ChatTile(
                      name: "Study Group 101",
                      message: "David: I shared the notes in the drive.",
                      time: "Yesterday",
                    ),
                    ChatTile(
                      name: "Alex Chen",
                      message: "Can you send me the prof's email?",
                      time: "Tue",
                      isSent: true,
                    ),
                    ChatTile(
                      name: "Sarah W.",
                      message: "Thanks for the help!",
                      time: "Mon",
                      isSent: true,
                    ),
                    ChatTile(
                      name: "Football Club",
                      message: "Practice moved to 5 PM.",
                      time: "Sun",
                    ),
                    ChatTile(
                      name: "Mark",
                      message: "Let's catch up soon.",
                      time: "Last week",
                    ),
                    ChatTile(
                      name: "Emily",
                      message: "Is the library open late today?",
                      time: "Last week",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

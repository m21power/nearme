import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/utils/normalize_time.dart';
import 'package:nearme/features/chat/domain/entities/chat_model.dart';
import 'package:nearme/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:nearme/features/chat/presentation/pages/message_page.dart';

import '../../../home/presentation/StoryBlock/story_bloc.dart';
import '../../../home/presentation/widgets/Story/story_widget.dart';
import '../widgets/chat_tile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return BlocConsumer<StoryBloc, StoryState>(
      listener: (context, storyState) {
        // TODO: implement listener
      },
      builder: (context, storyState) {
        return BlocConsumer<ChatBloc, ChatState>(
          listener: (context, chatState) {
            // TODO: implement listener
          },
          builder: (context, chatState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChatBloc>().add(LoadUserChatsEvent());
              },
              child: Scaffold(
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
                            Text(
                              "Messages",
                              style: theme.textTheme.headlineLarge,
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
                        StoryWidget(storyState: storyState),
                        const SizedBox(height: 10),

                        /// CHAT LIST
                        Expanded(
                          child: ListView.builder(
                            itemCount: chatState.chats.length,
                            itemBuilder: (context, index) {
                              ChatModel chat = chatState.chats[index];
                              final otherUserId = chat.users.firstWhere(
                                (id) => id != UserSession.instance.userId,
                              );
                              return GestureDetector(
                                onTap: () {
                                  context.read<ChatBloc>().add(
                                    LoadChatMessagesEvent(chatId: chat.chatId),
                                  );
                                  context.read<ChatBloc>().add(
                                    MarkMessagesReadEvent(chatId: chat.chatId),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MessagePage(chatId: chat.chatId),
                                    ),
                                  );
                                  print(chat.userProfilePics);
                                  print(chat.userNames);
                                  print(chat.unreadCounts);
                                },
                                child: ChatTile(
                                  profilePic:
                                      chat.userProfilePics[otherUserId] ?? "",

                                  name:
                                      chat.userNames[otherUserId] ?? "Unknown",
                                  message: chat.lastMessage,
                                  time: formatTimeAgo(
                                    chat.lastMessageAt.toIso8601String(),
                                  ),
                                  unreadCount:
                                      chat.unreadCounts[UserSession
                                          .instance
                                          .userId] ??
                                      0,
                                  isOnline:
                                      chat.userOnlineStatus[otherUserId] ??
                                      false,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

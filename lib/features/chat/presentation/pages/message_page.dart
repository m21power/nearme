import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/utils/normalize_time.dart';
import 'package:nearme/features/chat/domain/entities/chat_model.dart';
import 'package:nearme/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:nearme/features/chat/presentation/widgets/message_bubble.dart';

import '../../../../core/constant/user_session.dart';

class MessagePage extends StatefulWidget {
  final User? user;
  final String chatId;
  const MessagePage({super.key, required this.chatId, this.user});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool hasText = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        hasText = controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, chatState) {
        print("Chat State in UI: $chatState");
        if (chatState is ChatMessagesLoadedState) {
          // Scroll to bottom
          Future.delayed(const Duration(milliseconds: 100), () {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      builder: (context, chatState) {
        String profilePic = "";
        String name = "Unknown";
        String otherUserId = "";
        String isOnline = "offline";
        final messages = chatState.chatMessages[widget.chatId] ?? [];
        if (widget.user != null) {
          profilePic = widget.user!.profilePicUrl;
          name = widget.user!.name;
          otherUserId = widget.user!.userId;
        } else {
          final chat = chatState.chats.firstWhere(
            (c) => c.chatId == widget.chatId,
          );
          final secondUserId = chat.users.firstWhere(
            (id) => id != UserSession.instance.userId,
          );
          profilePic = chat.userProfilePics[secondUserId] ?? "";
          name = chat.userNames[secondUserId] ?? "Unknown";
          otherUserId = secondUserId;

          isOnline = chat.userOnlineStatus[secondUserId] == true
              ? "online"
              : "offline";
        }

        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: profilePic.isNotEmpty
                      ? NetworkImage(profilePic)
                      : null,
                  backgroundColor: theme.colorScheme.surface,
                  child: Text(name[0], style: theme.textTheme.bodyMedium),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isOnline,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: isOnline == "online"
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          body: Column(
            children: [
              /// MESSAGES
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Text(
                          "No messages yet. Start the conversation!",
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return MessageBubble(
                            status: message.status,
                            text: message.message,
                            time: formatTimeOnly(
                              message.timestamp.toIso8601String(),
                            ),
                            isMe:
                                message.senderId == UserSession.instance.userId,
                            isRead:
                                message.senderId ==
                                    UserSession.instance.userId &&
                                message.readBy.length > 1,
                          );
                        },
                      ),
              ),

              /// INPUT BAR
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Type a message...",
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// SEND OR EMOJI
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: hasText
                            ? IconButton(
                                key: const ValueKey("send"),
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  final text = controller.text.trim();
                                  if (text.isEmpty) return;

                                  context.read<ChatBloc>().add(
                                    SendMessageEvent(
                                      chatId: widget.chatId,
                                      message: text,
                                      otherUserId: otherUserId,
                                    ),
                                  );

                                  controller.clear();

                                  // Scroll to bottom
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () {
                                      if (scrollController.hasClients) {
                                        scrollController.animateTo(
                                          scrollController
                                              .position
                                              .maxScrollExtent,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    },
                                  );
                                },
                              )
                            : IconButton(
                                key: const ValueKey("emoji"),
                                icon: const Icon(Icons.emoji_emotions_outlined),
                                onPressed: () {},
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

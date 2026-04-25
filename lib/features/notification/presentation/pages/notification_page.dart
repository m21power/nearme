import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:nearme/features/profile/presentation/pages/user_profile_page.dart';

import '../../../home/presentation/pages/Connection/my_connection_page.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String getGroup(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Today";
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Yesterday";
    }

    return "Older";
  }

  Map<String, List<Map<String, dynamic>>> groupNotifications(
    List<Map<String, dynamic>> list,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      "Today": [],
      "Yesterday": [],
      "Older": [],
    };

    for (var item in list) {
      final date = item["time"] as DateTime;
      final group = getGroup(date);
      grouped[group]!.add(item);
    }

    return grouped;
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(MarkNotificationsAsReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var grouped = {"Today": [], "Yesterday": [], "Older": []};

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, notiState) {},
        builder: (context, notiState) {
          if (notiState is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notiState is NotificationError) {
            return Center(child: Text(notiState.message));
          }
          if (notiState is NotificationLoaded) {
            grouped = groupNotifications(
              notiState.notifications
                  .map(
                    (n) => {
                      "title": n.title,
                      "message": n.message,
                      "time": n.createdAt,
                      "isRead": n.isRead,
                      "type": n.type,
                      "senderId": n.senderId,
                    },
                  )
                  .toList(),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: grouped.entries.map((entry) {
              if (entry.value.isEmpty) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟦 Section title
                  Text(
                    entry.key,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🧾 Items
                  ...entry.value.map((item) {
                    final isRead = item["isRead"] as bool;

                    return GestureDetector(
                      onTap: () {
                        print(
                          "Tapped notification: ${item['title']} - ${item['type']}",
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                UserProfilePage(userId: item['senderId']),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isRead
                                ? Colors.transparent
                                : theme.colorScheme.primary.withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isRead
                                    ? Colors.transparent
                                    : theme.colorScheme.primary,
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"],
                                    style: TextStyle(
                                      fontWeight: isRead
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item["message"],
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

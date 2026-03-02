import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/normalize_time.dart';
import '../../ConnectionBlock/connection_bloc.dart';

class RequestWidget extends StatelessWidget {
  final ConnectionStates conState;
  const RequestWidget({super.key, required this.conState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ...conState.requests.request.map(
          (user) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: user.profilePicUrl.isNotEmpty
                              ? NetworkImage(user.profilePicUrl)
                              : null,
                          child: user.profilePicUrl.isEmpty
                              ? const Icon(Icons.person, size: 24)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${user.dept} · ${user.year}",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formatTimeAgo(user.requestedAt),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<ConnectionBloc>().add(
                                RespondToConnectionRequestEvent(
                                  connectionId: user.connectionId,
                                  notificationsId: user.notificationId,
                                  accept: true,
                                ),
                              );
                            },
                            child: const Text("Confirm"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<ConnectionBloc>().add(
                                RespondToConnectionRequestEvent(
                                  connectionId: user.connectionId,
                                  notificationsId: user.notificationId,
                                  accept: false,
                                ),
                              );
                            },
                            child: const Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

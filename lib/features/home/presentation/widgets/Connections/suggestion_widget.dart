import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ConnectionBlock/connection_bloc.dart';

class SuggestionWidget extends StatefulWidget {
  final ConnectionStates conState;
  const SuggestionWidget({super.key, required this.conState});

  @override
  State<SuggestionWidget> createState() => _SuggestionWidgetState();
}

class _SuggestionWidgetState extends State<SuggestionWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SizedBox(
        height: 250,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.conState.suggestions.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final user = widget.conState.suggestions[index];

            return SizedBox(
              width: 200,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: user.profilePicUrl.isNotEmpty
                            ? NetworkImage(user.profilePicUrl)
                            : null,
                        child: user.profilePicUrl.isEmpty
                            ? const Icon(Icons.person, size: 28)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.dept,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      IconButton(
                        onPressed: () {
                          if (user.requested == null) {
                            context.read<ConnectionBloc>().add(
                              SendConnectionRequestEvent(userId: user.userId),
                            );
                          } else {
                            // Cancel connection request
                          }
                        },
                        icon: Icon(
                          user.requested != null
                              ? Icons.done
                              : Icons.person_add,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

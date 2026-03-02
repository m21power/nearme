import 'package:flutter/material.dart';
import 'package:nearme/core/utils/normalize_time.dart';

import '../../ConnectionBlock/connection_bloc.dart';

Widget buildConnected(ThemeData theme, ConnectionStates conState) {
  if (conState.connectedUser.isEmpty) {
    return Center(
      child: Text("No connections yet", style: theme.textTheme.bodyMedium),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: conState.connectedUser.length,
    itemBuilder: (context, index) {
      final user = conState.connectedUser[index];

      return Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            backgroundImage: user.profilePicUrl.isNotEmpty
                ? NetworkImage(user.profilePicUrl)
                : null,
            radius: 24,
            child: Icon(Icons.person, size: 24),
          ),
          title: Text(
            user.name,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(user.dept, style: theme.textTheme.bodyMedium),
          trailing: Text(
            formatTimeAgo(user.connectedAt),
            style: theme.textTheme.bodyMedium,
          ), // later we will change with the online status
          onTap: () {
            // Navigate to chat page
          },
        ),
      );
    },
  );
}

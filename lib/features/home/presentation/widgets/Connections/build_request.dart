import 'package:flutter/material.dart';
import 'package:nearme/features/home/presentation/widgets/Connections/request_widget.dart';
import 'package:nearme/features/home/presentation/widgets/Connections/suggestion_widget.dart';

import '../../ConnectionBlock/connection_bloc.dart';

Widget buildRequests(ThemeData theme, ConnectionStates conState) {
  int requests = conState.requests.unseenCount < 0
      ? 0
      : conState.requests.unseenCount;
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Row(
        children: [
          Text(
            "New Requests",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 16),
            child: Text(
              requests > 9 ? '9+' : '$requests',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // ---------- REQUEST LIST ----------
      conState.requests.request.isEmpty
          ? Center(
              child: Text(
                "No new connection requests",
                style: theme.textTheme.bodyMedium,
              ),
            )
          : RequestWidget(conState: conState),

      const SizedBox(height: 24),

      // ---------- PEOPLE YOU MIGHT KNOW ----------
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "People You Might Know",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      const SizedBox(height: 16),
      conState.suggestions.isEmpty
          ? Center(
              child: Text(
                "No suggestions available",
                style: theme.textTheme.bodyMedium,
              ),
            )
          : SuggestionWidget(conState: conState),
    ],
  );
}

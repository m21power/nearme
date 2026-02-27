import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String content;
  const DeleteDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      title: Text(
        "Delete $content",
        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Are you sure you want to delete this $content?",
        style: textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel", style: textTheme.bodyMedium),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme.error),
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}

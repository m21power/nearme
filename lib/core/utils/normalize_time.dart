import 'package:intl/intl.dart';

String formatTimeAgo(String dateString) {
  final dateTime = DateTime.parse(dateString);
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return "now";
  }

  if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return minutes == 1 ? "1 minute ago" : "$minutes minutes ago";
  }

  if (difference.inHours < 24) {
    final hours = difference.inHours;
    return hours == 1 ? "1 hour ago" : "$hours hours ago";
  }

  if (difference.inDays < 7) {
    final days = difference.inDays;
    return days == 1 ? "1 day ago" : "$days days ago";
  }

  // More than 7 days → show date with time
  return DateFormat("MMM d, h:mm a").format(dateTime);
}

String formatTimeOnly(String dateString) {
  final dateTime = DateTime.parse(dateString);
  return DateFormat("h:mm a").format(dateTime);
}

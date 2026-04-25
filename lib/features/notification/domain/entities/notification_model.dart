class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String senderId;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.senderId,
    required this.createdAt,
    required this.isRead,
  });
}

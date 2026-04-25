class ChatModel {
  final String chatId;
  final List<String> users;
  final String lastMessage;
  final DateTime lastMessageAt;
  final Map<String, int> unreadCounts; // userId: unreadCount
  final Map<dynamic, dynamic> userNames; // userId: userName
  final Map<dynamic, dynamic> userProfilePics; // userId: profilePicUrl
  final Map<dynamic, bool> userOnlineStatus; // userId: isOnline

  ChatModel({
    required this.chatId,
    required this.users,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCounts,
    required this.userNames,
    required this.userProfilePics,
    required this.userOnlineStatus,
  });
}

enum MessageStatus { sending, sent, failed }

class MessageModel {
  final String messageId;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final List<String> readBy;
  final MessageStatus status;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.readBy,
    this.status = MessageStatus.sent,
  });

  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? message,
    DateTime? timestamp,
    List<String>? readBy,
    MessageStatus? status,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
      status: status ?? this.status,
    );
  }
}

class User {
  final String userId;
  final String name;
  final String profilePicUrl;

  User({required this.userId, required this.name, required this.profilePicUrl});
}

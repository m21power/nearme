class PostModel {
  final String userName;
  final String department;
  final String timeAgo;
  final String? caption;
  final String? imageUrl;
  final int likes;
  final int comments;

  PostModel({
    required this.userName,
    required this.department,
    required this.timeAgo,
    this.caption,
    this.imageUrl,
    required this.likes,
    required this.comments,
  });
}

class StoryModel {
  final String name;
  final String imageUrl;
  final bool isSeen;

  StoryModel({
    required this.name,
    required this.imageUrl,
    required this.isSeen,
  });
}

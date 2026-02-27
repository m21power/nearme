import 'package:nearme/features/home/domain/entities/comment_model.dart';

class PostModel {
  final bool isLiked;
  final String postId;
  final String userId;
  final String userName;
  final String? userProfile;
  final String dept;
  final String createdAt;
  final String? caption;
  final String? imageUrl;
  final int likes;
  final int comments;

  PostModel({
    required this.isLiked,
    this.userProfile,
    required this.postId,
    required this.userName,
    required this.userId,
    required this.dept,
    required this.createdAt,
    this.caption,
    this.imageUrl,
    required this.likes,
    required this.comments,
  });

  PostModel copyWith({
    bool? isLiked,
    String? postId,
    String? userId,
    String? userName,
    String? userProfile,
    String? dept,
    String? createdAt,
    String? caption,
    String? imageUrl,
    int? likes,
    int? comments,
  }) {
    return PostModel(
      isLiked: isLiked ?? this.isLiked,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfile: userProfile ?? this.userProfile,
      dept: dept ?? this.dept,
      createdAt: createdAt ?? this.createdAt,
      caption: caption ?? this.caption,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }
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

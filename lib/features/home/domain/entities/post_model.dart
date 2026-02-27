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
  final String storyId;
  final String authorId;
  final String authorUrl;
  final String authorName;
  final String mediaUrl;
  final String caption;
  final String createdAt;
  final String expiresAt;
  final int viewerCount;
  final int likeCount;
  final bool isSeen;
  final bool isLiked;

  StoryModel({
    required this.storyId,
    required this.authorId,
    required this.mediaUrl,
    required this.caption,
    required this.createdAt,
    required this.expiresAt,
    required this.viewerCount,
    required this.likeCount,
    required this.authorName,
    required this.authorUrl,
    required this.isSeen,
    required this.isLiked,
  });

  StoryModel copyWith({
    String? storyId,
    String? authorId,
    String? mediaUrl,
    String? caption,
    String? createdAt,
    String? expiresAt,
    int? viewerCount,
    int? likeCount,
    String? authorName,
    String? authorUrl,
    bool? isSeen,
    bool? isLiked,
  }) {
    return StoryModel(
      storyId: storyId ?? this.storyId,
      authorId: authorId ?? this.authorId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      viewerCount: viewerCount ?? this.viewerCount,
      likeCount: likeCount ?? this.likeCount,
      authorName: authorName ?? this.authorName,
      authorUrl: authorUrl ?? this.authorUrl,
      isSeen: isSeen ?? this.isSeen,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class ViewerModel {
  final String viewerId;
  final String viewerName;
  final String viewerProfileUrl;
  final String seenAt;
  final bool isLiked;

  ViewerModel({
    required this.viewerId,
    required this.viewerName,
    required this.viewerProfileUrl,
    required this.seenAt,
    required this.isLiked,
  });
}

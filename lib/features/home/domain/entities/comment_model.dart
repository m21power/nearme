class CommentModel {
  final String? id;
  final String userId;
  final String userName;
  final String? imageUrl;
  final String? createdAt;
  final String? dept;
  final String comment;
  CommentModel({
    this.id,
    required this.userId,
    required this.userName,
    this.imageUrl,
    this.createdAt,
    this.dept,
    required this.comment,
  });
}

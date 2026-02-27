import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/comment_model.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';

abstract class HomeRepository {
  // Future<List<PostModel>> fetchPosts();
  Future<Either<Failure, PostModel>> createPost(
    String? caption,
    String? imagePath,
  );
  Future<Either<Failure, List<PostModel>>> fetchPosts();
  Future<void> likePost(String postId);
  Future<void> commentOnPost(String postId, String comment);
  Future<Either<Failure, List<CommentModel>>> fetchComments(String postId);
  Future<void> deletePost(String postId);

  Future<void> deleteComment(String commentId);
  Future<Either<Failure, List<PostModel>>> fetchMyPost();
}

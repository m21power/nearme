import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';

abstract class HomeRepository {
  // Future<List<PostModel>> fetchPosts();
  Future<Either<Failure, PostModel>> createPost(
    String? caption,
    String? imagePath,
  );
  Future<Either<Failure, List<PostModel>>> fetchPosts();
  Future<void> likePost(String postId);
}

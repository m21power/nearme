import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';

abstract class StoryRepository {
  Future<Either<Failure, StoryModel>> createStory(
    String imagePath,
    String? caption,
  );
  Future<Either<Failure, List<StoryModel>>> fetchStories();
  Future<void> deleteStory(String storyId);
  Future<void> markStoryAsSeen(String storyId);
  Future<Either<Failure, List<ViewerModel>>> fetchViewer(String storyId);
  Future<void> likeStory(String storyId);
}

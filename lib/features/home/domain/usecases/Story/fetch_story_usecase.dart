import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/repository/story_repository.dart';

class FetchStoryUsecase {
  final StoryRepository storyRepository;
  FetchStoryUsecase({required this.storyRepository});
  Future<Either<Failure, List<StoryModel>>> call() {
    return storyRepository.fetchStories();
  }
}

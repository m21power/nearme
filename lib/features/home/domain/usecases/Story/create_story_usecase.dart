import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/repository/story_repository.dart';

class CreateStoryUsecase {
  final StoryRepository storyRepository;
  CreateStoryUsecase({required this.storyRepository});
  Future<Either<Failure, StoryModel>> call(String imagePath, String? caption) {
    return storyRepository.createStory(imagePath, caption);
  }
}

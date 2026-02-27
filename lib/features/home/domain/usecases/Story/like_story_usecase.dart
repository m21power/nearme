import 'package:nearme/features/home/domain/repository/story_repository.dart';

class LikeStoryUsecase {
  final StoryRepository storyRepository;
  LikeStoryUsecase({required this.storyRepository});
  Future<void> call(String storyId) {
    return storyRepository.likeStory(storyId);
  }
}

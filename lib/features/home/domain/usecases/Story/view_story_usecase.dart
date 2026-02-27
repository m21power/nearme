import 'package:nearme/features/home/domain/repository/story_repository.dart';

class ViewStoryUsecase {
  final StoryRepository storyRepository;
  ViewStoryUsecase({required this.storyRepository});
  Future<void> call(String storyId) {
    return storyRepository.markStoryAsSeen(storyId);
  }
}

import 'package:nearme/features/home/domain/repository/story_repository.dart';

class DeleteStoryUsecase {
  final StoryRepository storyRepository;
  DeleteStoryUsecase({required this.storyRepository});
  Future<void> call(String storyId) {
    return storyRepository.deleteStory(storyId);
  }
}

part of 'story_bloc.dart';

sealed class StoryState extends Equatable {
  final List<StoryModel> stories;
  final Map<String, List<ViewerModel>> viewers; // storyId -> List of viewers
  const StoryState({required this.stories, required this.viewers});

  @override
  List<Object> get props => [stories, viewers];
}

final class StoryInitial extends StoryState {
  const StoryInitial() : super(stories: const [], viewers: const {});
}

final class StoryLoading extends StoryState {
  const StoryLoading({
    required List<StoryModel> stories,
    required Map<String, List<ViewerModel>> viewers,
  }) : super(stories: stories, viewers: viewers);
}

final class CreateStoryInProgress extends StoryState {
  const CreateStoryInProgress({
    required List<StoryModel> stories,
    required Map<String, List<ViewerModel>> viewers,
  }) : super(stories: stories, viewers: viewers);
}

final class StoryError extends StoryState {
  final String message;
  const StoryError({
    required this.message,
    required List<StoryModel> stories,
    required Map<String, List<ViewerModel>> viewers,
  }) : super(stories: stories, viewers: viewers);
  @override
  List<Object> get props => [message, stories, viewers];
}

final class StoryCreated extends StoryState {
  const StoryCreated({
    required List<StoryModel> stories,
    required Map<String, List<ViewerModel>> viewers,
  }) : super(stories: stories, viewers: viewers);
}

final class StoriesFetched extends StoryState {
  const StoriesFetched({
    required List<StoryModel> stories,
    required Map<String, List<ViewerModel>> viewers,
  }) : super(stories: stories, viewers: viewers);
}

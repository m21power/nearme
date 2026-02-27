part of 'story_bloc.dart';

sealed class StoryEvent extends Equatable {
  const StoryEvent();

  @override
  List<Object> get props => [];
}

class CreateStoryEvent extends StoryEvent {
  final String imagePath;
  final String? caption;

  const CreateStoryEvent({required this.imagePath, this.caption});

  @override
  List<Object> get props => [imagePath, caption ?? ''];
}

class FetchStoriesEvent extends StoryEvent {}

class ViewStoryEvent extends StoryEvent {
  final String storyId;

  const ViewStoryEvent({required this.storyId});

  @override
  List<Object> get props => [storyId];
}

class DeleteStoryEvent extends StoryEvent {
  final String storyId;

  const DeleteStoryEvent({required this.storyId});

  @override
  List<Object> get props => [storyId];
}

class FetchViewerEvent extends StoryEvent {
  final String storyId;

  const FetchViewerEvent({required this.storyId});

  @override
  List<Object> get props => [storyId];
}

class LikeStoryEvent extends StoryEvent {
  final String storyId;

  const LikeStoryEvent({required this.storyId});

  @override
  List<Object> get props => [storyId];
}

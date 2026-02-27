import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/usecases/Story/create_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/delete_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/fetch_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/fetch_viewer_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/like_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/view_story_usecase.dart';

import '../../../../core/constant/user_session.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final CreateStoryUsecase createStoryUsecase;
  final FetchStoryUsecase fetchStoryUsecase;
  final DeleteStoryUsecase deleteStoryUsecase;
  final ViewStoryUsecase viewStoryUsecase;
  final FetchViewerUseCase fetchViewerUsecase;
  final LikeStoryUsecase likeStoryUsecase;
  StoryBloc({
    required this.createStoryUsecase,
    required this.fetchStoryUsecase,
    required this.deleteStoryUsecase,
    required this.viewStoryUsecase,
    required this.fetchViewerUsecase,
    required this.likeStoryUsecase,
  }) : super(StoryInitial()) {
    on<FetchStoriesEvent>((event, emit) async {
      emit(StoryLoading(stories: state.stories, viewers: state.viewers));
      final result = await fetchStoryUsecase();
      result.fold(
        (failure) => emit(
          StoryError(
            message: failure.message,
            stories: state.stories,
            viewers: state.viewers,
          ),
        ),
        (stories) {
          // make the wehre story.userId == UserSession.instance.userId story at the front
          final userStoryIndex = stories.indexWhere(
            (story) => story.authorId == UserSession.instance.userId,
          );
          if (userStoryIndex != -1) {
            final userStory = stories.removeAt(userStoryIndex);

            stories.insert(0, userStory);
          }

          // sort from unseen to seen
          stories.sort((a, b) {
            if (a.isSeen == b.isSeen) {
              return 0;
            } else if (a.isSeen) {
              return 1;
            } else {
              return -1;
            }
          });

          emit(StoriesFetched(stories: stories, viewers: state.viewers));
        },
      );
    });
    on<CreateStoryEvent>((event, emit) async {
      emit(
        CreateStoryInProgress(stories: state.stories, viewers: state.viewers),
      );
      final result = await createStoryUsecase(event.imagePath, event.caption);
      result.fold(
        (failure) => emit(
          StoryError(
            message: failure.message,
            stories: state.stories,
            viewers: state.viewers,
          ),
        ),
        (story) {
          final updatedStories = List<StoryModel>.from(state.stories)
            ..insert(0, story);
          emit(StoryCreated(stories: updatedStories, viewers: state.viewers));
        },
      );
    });

    on<DeleteStoryEvent>((event, emit) async {
      await deleteStoryUsecase(event.storyId);
      final updatedStories = state.stories
          .where((story) => story.storyId != event.storyId)
          .toList();
      emit(StoriesFetched(stories: updatedStories, viewers: state.viewers));
    });

    on<ViewStoryEvent>((event, emit) async {
      await viewStoryUsecase(event.storyId);
      final updatedStories = state.stories.map((story) {
        if (story.storyId == event.storyId) {
          return story.copyWith(isSeen: true);
        }
        return story;
      }).toList();
      emit(StoriesFetched(stories: updatedStories, viewers: state.viewers));
    });
    on<FetchViewerEvent>((event, emit) async {
      final result = await fetchViewerUsecase(event.storyId);
      result.fold(
        (failure) => emit(
          StoryError(
            message: failure.message,
            stories: state.stories,
            viewers: state.viewers,
          ),
        ),
        (viewers) {
          final updatedViewers = Map<String, List<ViewerModel>>.from(
            state.viewers,
          )..[event.storyId] = viewers;
          emit(StoriesFetched(stories: state.stories, viewers: updatedViewers));
        },
      );
    });
    on<LikeStoryEvent>((event, emit) async {
      await likeStoryUsecase(event.storyId);
      add(FetchStoriesEvent());
    });
  }
}

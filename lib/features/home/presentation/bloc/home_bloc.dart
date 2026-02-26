import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/usecases/create_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/fetch_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/like_post_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CreatePostUsecase createPostUsecase;
  final FetchPostUsecase fetchPostUsecase;
  final LikePostUsecase likePostUsecase;
  HomeBloc({
    required this.createPostUsecase,
    required this.fetchPostUsecase,
    required this.likePostUsecase,
  }) : super(HomeInitial()) {
    on<CreatePostEvent>((event, emit) async {
      emit(CreatePostLoading(posts: state.posts));
      final result = await createPostUsecase(event.caption, event.imagePath);
      result.fold((failure) => emit(HomeError(message: failure.message)), (
        post,
      ) {
        final updatedPosts = List<PostModel>.from(state.posts)..insert(0, post);
        emit(PostCreatedState(posts: updatedPosts));
      });
    });
    on<FetchPostsEvent>((event, emit) async {
      emit(FetchPostsLoading(posts: state.posts));
      final result = await fetchPostUsecase();
      result.fold(
        (failure) => emit(HomeError(message: failure.message)),
        (posts) => emit(PostsFetched(posts: posts)),
      );
    });

    on<LikePostEvent>((event, emit) async {
      final currentState = state;

      if (currentState is PostsFetched) {
        final updatedPosts = currentState.posts.map((post) {
          if (post.postId == event.postId) {
            final isCurrentlyLiked = post.isLiked;

            return post.copyWith(
              isLiked: !isCurrentlyLiked,
              likes: isCurrentlyLiked ? post.likes - 1 : post.likes + 1,
            );
          }
          return post;
        }).toList();
        emit(PostsFetched(posts: updatedPosts));
        await likePostUsecase(event.postId);
      }
    });
  }
}

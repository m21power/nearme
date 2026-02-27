import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/usecases/Post/comment_on_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/create_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/delete_comment_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/delete_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/fetch_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/like_post_usecase.dart';

import '../../domain/entities/comment_model.dart';
import '../../domain/usecases/Post/fetch_comment_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CreatePostUsecase createPostUsecase;
  final FetchPostUsecase fetchPostUsecase;
  final LikePostUsecase likePostUsecase;
  final CommentOnPostUsecase commentOnPostUsecase;
  final FetchCommentUsecase fetchCommentsUsecase;
  final DeleteCommentUsecase deleteCommentUsecase;
  final DeletePostUsecase deletePostUsecase;
  HomeBloc({
    required this.createPostUsecase,
    required this.fetchPostUsecase,
    required this.likePostUsecase,
    required this.commentOnPostUsecase,
    required this.fetchCommentsUsecase,
    required this.deleteCommentUsecase,
    required this.deletePostUsecase,
  }) : super(HomeInitial()) {
    on<CreatePostEvent>((event, emit) async {
      emit(CreatePostLoading(posts: state.posts));
      final result = await createPostUsecase(event.caption, event.imagePath);
      result.fold(
        (failure) =>
            emit(HomeError(message: failure.message, posts: state.posts)),
        (post) {
          final updatedPosts = List<PostModel>.from(state.posts)
            ..insert(0, post);
          emit(PostCreatedState(posts: updatedPosts));
        },
      );
    });
    on<FetchPostsEvent>((event, emit) async {
      emit(FetchPostsLoading(posts: state.posts));
      final result = await fetchPostUsecase();
      result.fold(
        (failure) =>
            emit(HomeError(message: failure.message, posts: state.posts)),
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

    on<DisplayCommentSectionEvent>((event, emit) {
      final currentState = state;
      emit(
        DisplayCommentSectionState(
          postId: event.postId,
          posts: currentState.posts,
        ),
      );
    });
    on<CommentOnPostEvent>((event, emit) async {
      await commentOnPostUsecase(event.postId, event.comment);
      // Optionally, you can also update the local state to reflect the new comment count
      final currentState = state;
      if (currentState is PostsFetched) {
        final updatedPosts = currentState.posts.map((post) {
          if (post.postId == event.postId) {
            return post.copyWith(comments: post.comments + 1);
          }
          return post;
        }).toList();
        emit(PostsFetched(posts: updatedPosts));
      }
    });
    on<FetchCommentsEvent>((event, emit) async {
      emit(CommentLoadingState(postId: event.postId, posts: state.posts));
      final result = await fetchCommentsUsecase(event.postId);

      result.fold(
        (failure) =>
            emit(HomeError(message: failure.message, posts: state.posts)),
        (comments) {
          final updatedCommentsByPost = Map<String, List<CommentModel>>.from(
            state.commentsByPost,
          )..[event.postId] = comments;
          final updatedPosts = state.posts.map((post) {
            if (post.postId == event.postId) {
              return post.copyWith(comments: comments.length);
            }
            return post;
          }).toList();

          emit(
            FetchCommentsState(
              postId: event.postId,
              posts: updatedPosts,
              commentsByPost: updatedCommentsByPost,
              timestamp: DateTime.now().toString(),
            ),
          );
        },
      );
    });
    on<DeleteCommentEvent>((event, emit) async {
      await deleteCommentUsecase(event.commentId);
      add(FetchPostsEvent());
    });
    on<DeletePostEvent>((event, emit) async {
      await deletePostUsecase(event.postId);
      add(FetchPostsEvent());
    });
  }
}

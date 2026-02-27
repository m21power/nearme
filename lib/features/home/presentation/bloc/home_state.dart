part of 'home_bloc.dart';

class HomeState {
  final List<PostModel> posts;
  final Map<String, List<CommentModel>> commentsByPost;

  const HomeState({required this.posts, required this.commentsByPost});

  HomeState copyWith({
    List<PostModel>? posts,
    Map<String, List<CommentModel>>? commentsByPost,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      commentsByPost: commentsByPost ?? this.commentsByPost,
    );
  }
}

final class HomeInitial extends HomeState {
  const HomeInitial() : super(posts: const [], commentsByPost: const {});
}

final class CreatePostLoading extends HomeState {
  const CreatePostLoading({required List<PostModel> posts})
    : super(posts: posts, commentsByPost: const {});
}

final class FetchPostsLoading extends HomeState {
  const FetchPostsLoading({required List<PostModel> posts})
    : super(posts: posts, commentsByPost: const {});
}

final class PostsFetched extends HomeState {
  const PostsFetched({required List<PostModel> posts})
    : super(posts: posts, commentsByPost: const {});
}

final class PostCreatedState extends HomeState {
  const PostCreatedState({required List<PostModel> posts})
    : super(posts: posts, commentsByPost: const {});
}

final class DisplayCommentSectionState extends HomeState {
  final String postId;
  const DisplayCommentSectionState({
    required this.postId,
    required List<PostModel> posts,
  }) : super(posts: posts, commentsByPost: const {});
}

final class FetchCommentsState extends HomeState {
  final String timestamp;
  final String postId;
  final Map<String, List<CommentModel>> commentsByPost;
  const FetchCommentsState({
    required this.timestamp,
    required this.postId,
    required this.commentsByPost,
    required List<PostModel> posts,
  }) : super(posts: posts, commentsByPost: commentsByPost);
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message, required List<PostModel> posts})
    : super(posts: posts, commentsByPost: const {});
  @override
  List<Object> get props => [message, posts];
}

class PostCreated extends HomeState {
  final List<PostModel> post;
  const PostCreated({required this.post, required List<PostModel> posts})
    : super(posts: posts, commentsByPost: const {});
  @override
  List<Object> get props => [post, posts];
}

class CommentLoadingState extends HomeState {
  final String postId;
  const CommentLoadingState({
    required this.postId,
    required List<PostModel> posts,
  }) : super(posts: posts, commentsByPost: const {});
  @override
  List<Object> get props => [postId, posts];
}

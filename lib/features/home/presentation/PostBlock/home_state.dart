part of 'home_bloc.dart';

class HomeState {
  final List<PostModel> posts;
  final List<PostModel> myPosts;
  final Map<String, List<CommentModel>> commentsByPost;

  const HomeState({
    required this.posts,
    required this.myPosts,
    required this.commentsByPost,
  });

  HomeState copyWith({
    List<PostModel>? posts,
    List<PostModel>? myPosts,
    Map<String, List<CommentModel>>? commentsByPost,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      myPosts: myPosts ?? this.myPosts,
      commentsByPost: commentsByPost ?? this.commentsByPost,
    );
  }
}

final class HomeInitial extends HomeState {
  const HomeInitial()
    : super(posts: const [], myPosts: const [], commentsByPost: const {});
}

final class CreatePostLoading extends HomeState {
  const CreatePostLoading({
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
}

final class FetchPostsLoading extends HomeState {
  const FetchPostsLoading({
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
}

final class FetchMyPostsLoading extends HomeState {
  const FetchMyPostsLoading({
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
}

final class PostsFetched extends HomeState {
  const PostsFetched({
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
}

final class PostCreatedState extends HomeState {
  const PostCreatedState({
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
}

final class DisplayCommentSectionState extends HomeState {
  final String postId;
  const DisplayCommentSectionState({
    required this.postId,
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
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
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: commentsByPost);
}

class HomeError extends HomeState {
  final String message;
  const HomeError({
    required this.message,
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
  @override
  List<Object> get props => [message, posts, myPosts];
}

class PostCreated extends HomeState {
  final List<PostModel> post;
  const PostCreated({
    required this.post,
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
  @override
  List<Object> get props => [post, posts, myPosts];
}

class CommentLoadingState extends HomeState {
  final String postId;
  const CommentLoadingState({
    required this.postId,
    required List<PostModel> posts,
    required List<PostModel> myPosts,
  }) : super(posts: posts, myPosts: myPosts, commentsByPost: const {});
  @override
  List<Object> get props => [postId, posts, myPosts];
}

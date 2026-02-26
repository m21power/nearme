part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  final List<PostModel> posts;

  const HomeState({this.posts = const []});

  @override
  List<Object> get props => [posts];
}

final class HomeInitial extends HomeState {
  const HomeInitial() : super();
}

final class CreatePostLoading extends HomeState {
  const CreatePostLoading({required List<PostModel> posts})
    : super(posts: posts);
}

final class FetchPostsLoading extends HomeState {
  const FetchPostsLoading({required List<PostModel> posts})
    : super(posts: posts);
}

final class PostsFetched extends HomeState {
  const PostsFetched({required List<PostModel> posts}) : super(posts: posts);
}

final class PostCreatedState extends HomeState {
  const PostCreatedState({required List<PostModel> posts})
    : super(posts: posts);
}

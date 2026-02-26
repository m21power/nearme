part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class CreatePostEvent extends HomeEvent {
  final String? caption;
  final String? imagePath;

  const CreatePostEvent({this.caption, this.imagePath});

  @override
  List<Object> get props => [caption ?? "", imagePath ?? ""];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
  @override
  List<Object> get props => [message];
}

class PostCreated extends HomeState {
  final List<PostModel> post;
  const PostCreated({required this.post});
  @override
  List<Object> get props => [post];
}

class FetchPostsEvent extends HomeEvent {}

class LikePostEvent extends HomeEvent {
  final String postId;
  const LikePostEvent({required this.postId});
  @override
  List<Object> get props => [postId];
}

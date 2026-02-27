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

class FetchPostsEvent extends HomeEvent {}

class LikePostEvent extends HomeEvent {
  final String postId;
  const LikePostEvent({required this.postId});
  @override
  List<Object> get props => [postId];
}

class DisplayCommentSectionEvent extends HomeEvent {
  final String postId;
  const DisplayCommentSectionEvent({required this.postId});
  @override
  List<Object> get props => [postId];
}

class CommentOnPostEvent extends HomeEvent {
  final String postId;
  final String comment;
  const CommentOnPostEvent({required this.postId, required this.comment});
  @override
  List<Object> get props => [postId, comment];
}

class FetchCommentsEvent extends HomeEvent {
  final String postId;
  const FetchCommentsEvent({required this.postId});
  @override
  List<Object> get props => [postId];
}

class DeleteCommentEvent extends HomeEvent {
  final String commentId;
  const DeleteCommentEvent({required this.commentId});
  @override
  List<Object> get props => [commentId];
}

class DeletePostEvent extends HomeEvent {
  final String postId;
  const DeletePostEvent({required this.postId});
  @override
  List<Object> get props => [postId];
}

class FetchMyPostsEvent extends HomeEvent {}

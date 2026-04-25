part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileUploadingState extends ProfileState {}

final class ProfileUpdated extends ProfileState {
  final String imageUrl;
  const ProfileUpdated({required this.imageUrl});
  @override
  List<Object> get props => [imageUrl];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});
  @override
  List<Object> get props => [message];
}

class ProfileInfoUpdatingState extends ProfileState {}

class ProfileInfoUpdated extends ProfileState {}

class FetchingUserPostsState extends ProfileState {}

class UserPostsFetchedState extends ProfileState {
  final UserInfoModel userInfo;
  const UserPostsFetchedState({required this.userInfo});
  @override
  List<Object> get props => [userInfo];
}

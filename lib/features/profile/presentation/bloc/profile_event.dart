part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfilePictureEvent extends ProfileEvent {
  final String imagePath;
  const UpdateProfilePictureEvent(this.imagePath);
  @override
  List<Object> get props => [imagePath];
}

class UpdateBannerPhotoEvent extends ProfileEvent {
  final String imagePath;
  const UpdateBannerPhotoEvent(this.imagePath);
  @override
  List<Object> get props => [imagePath];
}

class UpdateProfileInfoEvent extends ProfileEvent {
  final Userinfo userinfo;
  const UpdateProfileInfoEvent({required this.userinfo});
  @override
  List<Object> get props => [userinfo];
}

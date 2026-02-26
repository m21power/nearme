import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nearme/features/profile/domain/entities/UserInfo.dart';
import 'package:nearme/features/profile/domain/usecases/update_banner_image_usecase.dart';
import 'package:nearme/features/profile/domain/usecases/update_profile_image_usecase.dart';
import 'package:nearme/features/profile/domain/usecases/update_user_info_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileImageUsecase updateProfileImageUsecase;
  final UpdateBannerImageUsecase updateBannerImageUsecase;
  final UpdateUserInfoUsecase updateUserInfoUsecase;
  ProfileBloc({
    required this.updateProfileImageUsecase,
    required this.updateBannerImageUsecase,
    required this.updateUserInfoUsecase,
  }) : super(ProfileInitial()) {
    on<UpdateProfilePictureEvent>((event, emit) async {
      emit(ProfileUploadingState());
      final result = await updateProfileImageUsecase(event.imagePath);
      result.fold(
        (failure) => emit(ProfileError(message: failure.message)),
        (imageUrl) => emit(ProfileUpdated(imageUrl: imageUrl)),
      );
    });

    on<UpdateBannerPhotoEvent>((event, emit) async {
      emit(ProfileUploadingState());
      final result = await updateBannerImageUsecase(event.imagePath);
      result.fold(
        (failure) => emit(ProfileError(message: failure.message)),
        (imageUrl) => emit(ProfileUpdated(imageUrl: imageUrl)),
      );
    });
    on<UpdateProfileInfoEvent>((event, emit) async {
      emit(ProfileInfoUpdatingState());
      final result = await updateUserInfoUsecase(event.userinfo);
      result.fold(
        (failure) => emit(ProfileError(message: failure.message)),
        (_) => emit(ProfileInfoUpdated()),
      );
    });
  }
}

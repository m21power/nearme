import 'package:dartz/dartz.dart';
import 'package:nearme/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/error/failure.dart';

class UpdateProfileImageUsecase {
  final ProfileRepository profileRepository;
  UpdateProfileImageUsecase({required this.profileRepository});
  Future<Either<Failure, String>> call(String imagePath) {
    return profileRepository.updateProfilePicture(imagePath);
  }
}

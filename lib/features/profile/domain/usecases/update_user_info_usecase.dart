import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/profile/domain/entities/UserInfo.dart';
import 'package:nearme/features/profile/domain/repository/profile_repository.dart';

class UpdateUserInfoUsecase {
  final ProfileRepository profileRepository;
  UpdateUserInfoUsecase({required this.profileRepository});
  Future<Either<Failure, void>> call(Userinfo userinfo) {
    return profileRepository.updateUserInfo(userinfo);
  }
}

import 'package:dartz/dartz.dart';
import 'package:nearme/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/post_model.dart';

class FetchUserPostUsecase {
  final ProfileRepository profileRepository;
  FetchUserPostUsecase({required this.profileRepository});
  Future<Either<Failure, UserInfoModel>> call(String userId) {
    return profileRepository.fetchUserPosts(userId);
  }
}

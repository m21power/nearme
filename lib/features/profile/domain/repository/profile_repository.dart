import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/profile/domain/entities/UserInfo.dart';

import '../../../home/domain/entities/post_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, String>> updateProfilePicture(String imagePath);
  Future<Either<Failure, String>> updateBannerPhoto(String imagePath);
  Future<Either<Failure, void>> updateUserInfo(Userinfo userinfo);
  Future<Either<Failure, UserInfoModel>> fetchUserPosts(String userId);
}

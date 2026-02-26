import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repository/profile_repository.dart';

class UpdateBannerImageUsecase {
  final ProfileRepository repository;
  UpdateBannerImageUsecase({required this.repository});
  Future<Either<Failure, String>> call(String imagePath) {
    return repository.updateBannerPhoto(imagePath);
  }
}

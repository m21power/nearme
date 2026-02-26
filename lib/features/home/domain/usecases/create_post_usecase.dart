import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/repository/home_repository.dart';

class CreatePostUsecase {
  final HomeRepository homeRepository;
  CreatePostUsecase({required this.homeRepository});
  Future<Either<Failure, PostModel>> call(String? caption, String? imagePath) {
    return homeRepository.createPost(caption, imagePath);
  }
}

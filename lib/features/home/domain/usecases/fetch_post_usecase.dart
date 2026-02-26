import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/repository/home_repository.dart';

class FetchPostUsecase {
  final HomeRepository homeRepository;
  FetchPostUsecase({required this.homeRepository});
  Future<Either<Failure, List<PostModel>>> call() {
    return homeRepository.fetchPosts();
  }
}

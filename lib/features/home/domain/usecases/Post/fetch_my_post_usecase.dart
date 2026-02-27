import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';

import '../../repository/home_repository.dart';

class FetchMyPostUsecase {
  final HomeRepository repository;

  FetchMyPostUsecase(this.repository);

  Future<Either<Failure, List<PostModel>>> call() async {
    return await repository.fetchMyPost();
  }
}

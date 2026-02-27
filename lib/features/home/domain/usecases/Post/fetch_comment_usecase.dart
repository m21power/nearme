import 'package:dartz/dartz.dart';
import 'package:nearme/features/home/domain/entities/comment_model.dart';
import 'package:nearme/features/home/domain/repository/home_repository.dart';

import '../../../../../core/error/failure.dart';

class FetchCommentUsecase {
  final HomeRepository homeRepository;
  FetchCommentUsecase({required this.homeRepository});
  Future<Either<Failure, List<CommentModel>>> call(String postId) {
    return homeRepository.fetchComments(postId);
  }
}

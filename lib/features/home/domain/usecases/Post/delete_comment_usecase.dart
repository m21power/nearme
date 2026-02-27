import 'package:nearme/features/home/domain/repository/home_repository.dart';

class DeleteCommentUsecase {
  final HomeRepository homeRepository;

  DeleteCommentUsecase({required this.homeRepository});
  Future<void> call(String commentId) async {
    await homeRepository.deleteComment(commentId);
  }
}

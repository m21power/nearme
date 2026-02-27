import 'package:nearme/features/home/domain/repository/home_repository.dart';

class CommentOnPostUsecase {
  final HomeRepository homeRepository;
  CommentOnPostUsecase({required this.homeRepository});
  Future<void> call(String postId, String comment) {
    return homeRepository.commentOnPost(postId, comment);
  }
}

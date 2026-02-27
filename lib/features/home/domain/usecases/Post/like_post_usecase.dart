import 'package:nearme/features/home/domain/repository/home_repository.dart';

class LikePostUsecase {
  final HomeRepository homeRepository;
  LikePostUsecase({required this.homeRepository});
  Future<void> call(String postId) async {
    await homeRepository.likePost(postId);
  }
}

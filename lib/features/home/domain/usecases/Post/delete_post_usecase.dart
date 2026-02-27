import 'package:nearme/features/home/domain/repository/home_repository.dart';

class DeletePostUsecase {
  final HomeRepository homeRepository;

  DeletePostUsecase({required this.homeRepository});
  Future<void> call(String postId) async {
    await homeRepository.deletePost(postId);
  }
}

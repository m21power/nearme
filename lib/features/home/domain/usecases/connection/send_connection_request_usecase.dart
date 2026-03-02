import 'package:nearme/features/home/domain/repository/connection_repository.dart';

class SendConnectionRequestUsecase {
  final ConnectionRepository connectionRepository;
  SendConnectionRequestUsecase({required this.connectionRepository});
  Future<void> call(String userId) async {
    await connectionRepository.sendConnectionRequest(userId);
  }
}

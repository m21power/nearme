import 'package:nearme/features/home/domain/repository/connection_repository.dart';

class RespondToConnectionRequestUsecase {
  final ConnectionRepository connectionRepository;
  RespondToConnectionRequestUsecase({required this.connectionRepository});
  Future<void> call(
    String connectionId,
    String notificationsId,
    bool accept,
  ) async {
    await connectionRepository.respondToConnectionRequest(
      connectionId,
      notificationsId,
      accept,
    );
  }
}

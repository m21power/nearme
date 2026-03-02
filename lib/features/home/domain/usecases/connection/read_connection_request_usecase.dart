import 'package:nearme/features/home/domain/repository/connection_repository.dart';

class ReadConnectionRequestUsecase {
  final ConnectionRepository connectionRepository;
  ReadConnectionRequestUsecase({required this.connectionRepository});
  Future<void> call(String requestId) {
    return connectionRepository.readConnectionRequest(requestId);
  }
}

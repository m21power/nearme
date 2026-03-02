import 'package:dartz/dartz.dart';
import 'package:nearme/features/home/domain/repository/connection_repository.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/connection_model.dart';

class StreamConnectionRequestUsecase {
  final ConnectionRepository connectionRepository;
  StreamConnectionRequestUsecase({required this.connectionRepository});
  Stream<(List<ConnectionRequestModel>, int)> call() {
    return connectionRepository.streamConnectionRequests();
  }
}

import 'package:dartz/dartz.dart';
import 'package:nearme/features/home/domain/repository/connection_repository.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/connection_model.dart';

class GetConnectionUsecase {
  final ConnectionRepository connectionRepository;
  GetConnectionUsecase({required this.connectionRepository});
  Future<Either<Failure, List<ConnectionModel>>> call() {
    return connectionRepository.getConnections();
  }
}

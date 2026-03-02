import 'package:dartz/dartz.dart';
import 'package:nearme/features/home/domain/repository/connection_repository.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/connection_model.dart';

class GetSuggestionUserUsecase {
  final ConnectionRepository connectionRepository;
  GetSuggestionUserUsecase({required this.connectionRepository});
  Future<Either<Failure, List<ConnectionSuggestionModel>>> call() async {
    return await connectionRepository.getConnectionSuggestions();
  }
}

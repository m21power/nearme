import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/map/domain/entities/map_user.dart';
import 'package:nearme/features/map/domain/repository/map_repository.dart';

class GetNearbyUsersUsecase {
  final MapRepository mapRepository;
  GetNearbyUsersUsecase({required this.mapRepository});
  Future<Either<Failure, List<MapUser>>> call() {
    return mapRepository.getNearbyUsers();
  }
}

import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/map/domain/repository/map_repository.dart';

class UpdateUserLocationUsecase {
  final MapRepository mapRepository;
  UpdateUserLocationUsecase({required this.mapRepository});
  Future<Either<Failure, LatLng>> call() {
    return mapRepository.startAutoLocationUpdates();
  }
}

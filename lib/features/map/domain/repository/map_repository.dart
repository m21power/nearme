import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearme/core/error/failure.dart';

import '../entities/map_user.dart';

abstract class MapRepository {
  Future<Either<Failure, List<MapUser>>> getNearbyUsers();
  Stream<bool> listenToLocationStatus();
  Future<Either<Failure, LatLng>> startAutoLocationUpdates();
}

import 'package:nearme/features/map/domain/repository/map_repository.dart';

class ListenToLocationStatusUsecase {
  final MapRepository mapRepository;
  ListenToLocationStatusUsecase({required this.mapRepository});
  Stream<bool> call() {
    return mapRepository.listenToLocationStatus();
  }
}

import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/connection_model.dart';

abstract class ConnectionRepository {
  Future<void> sendConnectionRequest(String userId);
  Future<Either<Failure, List<ConnectionSuggestionModel>>>
  getConnectionSuggestions();
  Stream<(List<ConnectionRequestModel>, int)> streamConnectionRequests();
  Future<void> respondToConnectionRequest(
    String connectionId,
    String notificationsId,
    bool accept,
  );
  Future<void> readConnectionRequest(String notificationId);
  Future<Either<Failure, List<ConnectionModel>>> getConnections();
}

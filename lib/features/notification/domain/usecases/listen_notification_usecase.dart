import 'package:nearme/features/notification/domain/entities/notification_model.dart';
import 'package:nearme/features/notification/domain/repository/notification_repository.dart';

class ListenNotificationUsecase {
  final NotificationRepository repository;
  ListenNotificationUsecase({required this.repository});
  Stream<List<NotificationModel>> call() {
    return repository.listenNotifications();
  }
}

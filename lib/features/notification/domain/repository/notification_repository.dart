import 'package:nearme/features/notification/domain/entities/notification_model.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> listenNotifications();
  Future<void> markAsRead();
}

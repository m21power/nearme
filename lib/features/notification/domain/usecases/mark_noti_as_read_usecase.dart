import 'package:nearme/features/notification/domain/repository/notification_repository.dart';

class MarkNotiAsReadUsecase {
  final NotificationRepository repository;
  MarkNotiAsReadUsecase({required this.repository});
  Future<void> call() async {
    await repository.markAsRead();
  }
}

import 'package:nearme/features/chat/domain/repository/chat_repository.dart';

class MarkAsReadUsecase {
  final ChatRepository repository;

  MarkAsReadUsecase({required this.repository});

  Future<void> call(String chatId) async {
    await repository.markMessagesAsRead(chatId);
  }
}

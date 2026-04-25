import 'package:dartz/dartz.dart';
import 'package:nearme/features/chat/domain/entities/chat_model.dart';
import 'package:nearme/features/chat/domain/repository/chat_repository.dart';

import '../../../../core/error/failure.dart';

class SendMessageUsecase {
  final ChatRepository chatRepository;
  SendMessageUsecase({required this.chatRepository});
  Future<Either<Failure, MessageModel>> call(
    String chatId,
    String message,
    String otherUserId,
  ) {
    return chatRepository.sendMessage(chatId, message, otherUserId);
  }
}

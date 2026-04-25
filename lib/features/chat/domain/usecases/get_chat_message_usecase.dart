import 'package:dartz/dartz.dart';
import 'package:nearme/features/chat/domain/entities/chat_model.dart'
    show MessageModel;
import 'package:nearme/features/chat/domain/repository/chat_repository.dart';

import '../../../../core/error/failure.dart';

class GetChatMessageUsecase {
  final ChatRepository chatRepository;
  GetChatMessageUsecase({required this.chatRepository});
  Stream<Either<Failure, List<MessageModel>>> call(String chatId) {
    return chatRepository.getChatMessages(chatId);
  }
}

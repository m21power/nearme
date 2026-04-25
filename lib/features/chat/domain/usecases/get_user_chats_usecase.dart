import 'package:dartz/dartz.dart';
import 'package:nearme/features/chat/domain/repository/chat_repository.dart';

import '../../../../core/error/failure.dart';
import '../entities/chat_model.dart';

class GetUserChatsUsecase {
  final ChatRepository chatRepository;
  GetUserChatsUsecase({required this.chatRepository});
  Stream<Either<Failure, List<ChatModel>>> call() {
    return chatRepository.getUserChats();
  }
}

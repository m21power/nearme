import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/chat/domain/entities/chat_model.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<ChatModel>>> getUserChats();
  Future<Either<Failure, MessageModel>> sendMessage(
    String chatId,
    String message,
    String otherUserId,
  );
  Stream<Either<Failure, List<MessageModel>>> getChatMessages(String chatId);
  Future<void> markMessagesAsRead(String chatId);
}

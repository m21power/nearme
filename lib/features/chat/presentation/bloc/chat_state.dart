part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  final List<ChatModel> chats;
  final Map<String, List<MessageModel>> chatMessages; // chatId: messages
  const ChatState({this.chats = const [], this.chatMessages = const {}});

  @override
  List<Object> get props => [chats, chatMessages];
}

final class ChatInitial extends ChatState {}

final class ChatLoadingState extends ChatState {
  final Map<String, List<MessageModel>> chatMessages;
  final List<ChatModel> chats;
  const ChatLoadingState({required this.chats, required this.chatMessages})
    : super(chats: chats, chatMessages: chatMessages);
}

final class ChatLoadedState extends ChatState {
  final List<ChatModel> chats;
  final Map<String, List<MessageModel>> chatMessages;
  const ChatLoadedState({required this.chats, required this.chatMessages})
    : super(chats: chats, chatMessages: chatMessages);

  @override
  List<Object> get props => [chats, chatMessages];
}

class ChatErrorState extends ChatState {
  final String message;
  final List<ChatModel> chats;
  final Map<String, List<MessageModel>> chatMessages;
  const ChatErrorState({
    required this.message,
    required this.chats,
    required this.chatMessages,
  }) : super(chats: chats, chatMessages: chatMessages);

  @override
  List<Object> get props => [message, chats, chatMessages];
}

class ChatMessagesLoadingState extends ChatState {
  final List<ChatModel> chats;
  final Map<String, List<MessageModel>> chatMessages;
  const ChatMessagesLoadingState({
    required this.chats,
    required this.chatMessages,
  }) : super(chats: chats, chatMessages: chatMessages);
  @override
  List<Object> get props => [chats, chatMessages];
}

class ChatMessagesLoadedState extends ChatState {
  final List<ChatModel> chats;
  final Map<String, List<MessageModel>> chatMessages;
  const ChatMessagesLoadedState({
    required this.chats,
    required this.chatMessages,
  }) : super(chats: chats, chatMessages: chatMessages);
  @override
  List<Object> get props => [chats, chatMessages];
}

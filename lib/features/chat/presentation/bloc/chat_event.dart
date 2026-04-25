part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadUserChatsEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String message;
  final String otherUserId;

  const SendMessageEvent({
    required this.chatId,
    required this.message,
    required this.otherUserId,
  });

  @override
  List<Object> get props => [chatId, message, otherUserId];
}

class LoadChatMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadChatMessagesEvent({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class MarkMessagesReadEvent extends ChatEvent {
  final String chatId;

  const MarkMessagesReadEvent({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class UpdateStatusEvent extends ChatEvent {
  const UpdateStatusEvent();

  @override
  List<Object> get props => [];
}

class _EmitMessagesEvent extends ChatEvent {
  final String chatId;
  final List<MessageModel> messages;

  const _EmitMessagesEvent(this.chatId, this.messages);

  @override
  List<Object> get props => [chatId, messages];
}

class _EmitChatErrorEvent extends ChatEvent {
  final String message;

  const _EmitChatErrorEvent(this.message);

  @override
  List<Object> get props => [message];
}

class _EmitChatsLoadedEvent extends ChatEvent {
  final List<ChatModel> chats;

  const _EmitChatsLoadedEvent(this.chats);

  @override
  List<Object> get props => [chats];
}

class _EmitChatsErrorEvent extends ChatEvent {
  final String message;

  const _EmitChatsErrorEvent(this.message);

  @override
  List<Object> get props => [message];
}

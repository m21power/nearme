import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nearme/features/chat/domain/usecases/get_chat_message_usecase.dart';
import 'package:nearme/features/chat/domain/usecases/mark_as_read_usecase.dart';

import '../../../../core/constant/user_session.dart';
import '../../../../core/error/failure.dart';
import '../../data/repository/chat_repo_impl.dart';
import '../../domain/entities/chat_model.dart';
import '../../domain/usecases/get_user_chats_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetUserChatsUsecase getUserChatsUsecase;
  final SendMessageUsecase sendMessageUsecase;
  final GetChatMessageUsecase getChatMessagesUsecase;
  final MarkAsReadUsecase markAsReadUsecase;
  StreamSubscription<Either<Failure, List<MessageModel>>>?
  _messagesSubscription;
  StreamSubscription<Either<Failure, List<ChatModel>>>? _chatsSubscription;
  ChatBloc({
    required this.getUserChatsUsecase,
    required this.sendMessageUsecase,
    required this.getChatMessagesUsecase,
    required this.markAsReadUsecase,
  }) : super(ChatInitial()) {
    on<LoadUserChatsEvent>((event, emit) async {
      emit(
        ChatLoadingState(chats: state.chats, chatMessages: state.chatMessages),
      );

      await _chatsSubscription?.cancel();

      _chatsSubscription = getUserChatsUsecase().listen((result) {
        result.fold(
          (failure) {
            add(_EmitChatsErrorEvent(failure.message));
          },
          (chats) {
            add(_EmitChatsLoadedEvent(chats));
          },
        );
      });
    });
    on<_EmitChatsLoadedEvent>((event, emit) {
      emit(
        ChatLoadedState(chats: event.chats, chatMessages: state.chatMessages),
      );
    });

    on<_EmitChatsErrorEvent>((event, emit) {
      emit(
        ChatErrorState(
          message: event.message,
          chats: state.chats,
          chatMessages: state.chatMessages,
        ),
      );
    });
    on<SendMessageEvent>((event, emit) async {
      final tempMessage = MessageModel(
        messageId: "temp_${DateTime.now().millisecondsSinceEpoch}",
        senderId: UserSession.instance.userId!,
        message: event.message,
        timestamp: DateTime.now(),
        readBy: [UserSession.instance.userId!],
        status: MessageStatus.sending,
      );

      /// clone state
      final updated = Map<String, List<MessageModel>>.from(state.chatMessages);

      /// add temp message
      updated[event.chatId] = [...(updated[event.chatId] ?? []), tempMessage];

      emit(ChatMessagesLoadingState(chats: state.chats, chatMessages: updated));

      /// call server
      final result = await sendMessageUsecase(
        event.chatId,
        event.message,
        event.otherUserId,
      );

      result.fold(
        /// FAILURE
        (failure) {
          final failedMap = Map<String, List<MessageModel>>.from(
            state.chatMessages,
          );

          final list = failedMap[event.chatId] ?? [];

          final index = list.indexWhere(
            (m) => m.messageId == tempMessage.messageId,
          );

          if (index != -1) {
            list[index] = list[index].copyWith(status: MessageStatus.failed);
          }

          emit(
            ChatErrorState(
              message: failure.message,
              chats: state.chats,
              chatMessages: failedMap,
            ),
          );
        },

        /// SUCCESS
        (serverMessage) {
          final updatedMap = Map<String, List<MessageModel>>.from(
            state.chatMessages,
          );

          final list = updatedMap[event.chatId] ?? [];

          final index = list.indexWhere(
            (m) => m.messageId == tempMessage.messageId,
          );

          if (index != -1) {
            list[index] = serverMessage;
          }

          emit(
            ChatMessagesLoadedState(
              chats: state.chats,
              chatMessages: updatedMap,
            ),
          );
        },
      );
    });

    on<LoadChatMessagesEvent>((event, emit) async {
      emit(
        ChatMessagesLoadingState(
          chats: state.chats,
          chatMessages: state.chatMessages,
        ),
      );

      await _messagesSubscription?.cancel();

      _messagesSubscription = getChatMessagesUsecase(event.chatId).listen((
        result,
      ) {
        result.fold(
          (failure) {
            add(_EmitChatErrorEvent(failure.message));
          },
          (messages) {
            add(_EmitMessagesEvent(event.chatId, messages));
          },
        );
      });
    });
    on<_EmitMessagesEvent>((event, emit) {
      final updatedChatMessages = Map<String, List<MessageModel>>.from(
        state.chatMessages,
      );

      updatedChatMessages[event.chatId] = event.messages;

      emit(
        ChatMessagesLoadedState(
          chats: state.chats,
          chatMessages: updatedChatMessages,
        ),
      );
    });

    on<_EmitChatErrorEvent>((event, emit) {
      emit(
        ChatErrorState(
          message: event.message,
          chats: state.chats,
          chatMessages: state.chatMessages,
        ),
      );
    });
    on<MarkMessagesReadEvent>((event, emit) async {
      await markAsReadUsecase(event.chatId);
      add(LoadUserChatsEvent());
    });
    on<UpdateStatusEvent>((event, emit) async {
      ChatRepoImpl.updateUserStatus();
    });
  }
  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _chatsSubscription?.cancel();
    return super.close();
  }
}

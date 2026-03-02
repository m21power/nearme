import 'package:bloc/bloc.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:equatable/equatable.dart';
import 'package:nearme/features/home/domain/entities/connection_model.dart';
import 'package:nearme/features/home/domain/usecases/connection/get_connection_request_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/get_connection_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/get_suggestion_user_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/read_connection_request_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/respond_to_connection_request_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/send_connection_request_usecase.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionStates> {
  final GetSuggestionUserUsecase getSuggestionUserUsecase;
  final SendConnectionRequestUsecase sendConnectionRequestUsecase;
  final StreamConnectionRequestUsecase streamConnectionRequestUsecase;
  final ReadConnectionRequestUsecase readConnectionRequestUsecase;
  final RespondToConnectionRequestUsecase respondToConnectionRequestUsecase;
  final GetConnectionUsecase getConnectionUsecase;
  ConnectionBloc({
    required this.getSuggestionUserUsecase,
    required this.sendConnectionRequestUsecase,
    required this.streamConnectionRequestUsecase,
    required this.readConnectionRequestUsecase,
    required this.respondToConnectionRequestUsecase,
    required this.getConnectionUsecase,
  }) : super(ConnectionInitial()) {
    on<LoadConnectionSuggestionsEvent>((event, emit) async {
      emit(
        ConnectionLoadingState(
          suggestions: state.suggestions,
          requests: state.requests,
        ),
      );
      final result = await getSuggestionUserUsecase();
      result.fold(
        (failure) => emit(
          ConnectionErrorState(
            message: failure.message,
            suggestions: state.suggestions,
            requests: state.requests,
          ),
        ),
        (suggestions) => emit(
          ConnectionLoadedState(
            suggestions: suggestions,
            requests: state.requests,
            connectedUser: state.connectedUser,
          ),
        ),
      );
    });
    on<LoadConnectionRequestsEvent>((event, emit) async {
      emit(
        ConnectionLoadingState(
          suggestions: state.suggestions,
          requests: state.requests,
        ),
      );

      await emit.forEach<(List<ConnectionRequestModel>, int)>(
        streamConnectionRequestUsecase(),
        onData: (data) {
          final requests = data.$1;
          final unseenCount = data.$2;

          return ConnectionLoadedState(
            suggestions: state.suggestions,
            connectedUser: state.connectedUser,
            requests: RequestModel(request: requests, unseenCount: unseenCount),
          );
        },
        onError: (error, stackTrace) => ConnectionErrorState(
          message: error.toString(),
          suggestions: state.suggestions,
          requests: state.requests,
        ),
      );
    });
    on<SendConnectionRequestEvent>((event, emit) async {
      await sendConnectionRequestUsecase(event.userId);
      // i wanna update the sugessted user status
      final updatedSuggestions = state.suggestions.map((suggestion) {
        if (suggestion.userId == event.userId) {
          return suggestion.copyWith(requested: true);
        }
        return suggestion;
      }).toList();
      emit(
        ConnectionLoadedState(
          suggestions: updatedSuggestions,
          requests: state.requests,
          connectedUser: state.connectedUser,
        ),
      );
    });
    on<ReadConnectionRequestEvent>((event, emit) async {
      for (var request in state.requests.request) {
        await readConnectionRequestUsecase(request.notificationId);
      }
    });
    on<RespondToConnectionRequestEvent>((event, emit) async {
      await respondToConnectionRequestUsecase(
        event.connectionId,
        event.notificationsId,
        event.accept,
      );
      final updatedRequests = state.requests.request
          .where((request) => request.connectionId != event.connectionId)
          .toList();
      emit(
        ConnectionLoadedState(
          suggestions: state.suggestions,
          connectedUser: state.connectedUser,
          requests: RequestModel(
            request: updatedRequests,
            unseenCount: state.requests.unseenCount - 1,
          ),
        ),
      );
    });
    on<LoadConnectionsEvent>((event, emit) async {
      emit(
        ConnectionLoadingState(
          suggestions: state.suggestions,
          requests: state.requests,
          connectedUser: state.connectedUser,
        ),
      );
      final result = await getConnectionUsecase();
      result.fold(
        (failure) => emit(
          ConnectionErrorState(
            message: failure.message,
            suggestions: state.suggestions,
            requests: state.requests,
            connectedUser: state.connectedUser,
          ),
        ),
        (connections) => emit(
          ConnectionLoadedState(
            suggestions: state.suggestions,
            requests: state.requests,
            connectedUser: connections,
          ),
        ),
      );
    });
  }
}

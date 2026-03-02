part of 'connection_bloc.dart';

sealed class ConnectionStates extends Equatable {
  final List<ConnectionSuggestionModel> suggestions;
  final RequestModel requests;
  final List<ConnectionModel> connectedUser;
  const ConnectionStates({
    required this.suggestions,
    required this.requests,
    required this.connectedUser,
  });

  @override
  List<Object> get props => [suggestions, requests, connectedUser];
}

final class ConnectionInitial extends ConnectionStates {
  ConnectionInitial({
    List<ConnectionSuggestionModel> suggestions = const [],
    RequestModel requests = const RequestModel(request: [], unseenCount: 0),
    List<ConnectionModel> connectedUser = const [],
  }) : super(
         suggestions: suggestions,
         requests: requests,
         connectedUser: connectedUser,
       );
}

final class ConnectionLoadingState extends ConnectionStates {
  ConnectionLoadingState({
    List<ConnectionSuggestionModel> suggestions = const [],
    RequestModel requests = const RequestModel(request: [], unseenCount: 0),
    List<ConnectionModel> connectedUser = const [],
  }) : super(
         suggestions: suggestions,
         requests: requests,
         connectedUser: connectedUser,
       );
}

final class ConnectionErrorState extends ConnectionStates {
  final String message;
  ConnectionErrorState({
    required this.message,
    List<ConnectionSuggestionModel> suggestions = const [],
    RequestModel requests = const RequestModel(request: [], unseenCount: 0),
    List<ConnectionModel> connectedUser = const [],
  }) : super(
         suggestions: suggestions,
         requests: requests,
         connectedUser: connectedUser,
       );
}

final class ConnectionLoadedState extends ConnectionStates {
  ConnectionLoadedState({
    required List<ConnectionSuggestionModel> suggestions,
    required RequestModel requests,
    required List<ConnectionModel> connectedUser,
  }) : super(
         suggestions: suggestions,
         requests: requests,
         connectedUser: connectedUser,
       );
}

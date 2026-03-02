part of 'connection_bloc.dart';

sealed class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object> get props => [];
}

class LoadConnectionSuggestionsEvent extends ConnectionEvent {}

class SendConnectionRequestEvent extends ConnectionEvent {
  final String userId;
  const SendConnectionRequestEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadConnectionRequestsEvent extends ConnectionEvent {}

class ReadConnectionRequestEvent extends ConnectionEvent {
  const ReadConnectionRequestEvent();

  @override
  List<Object> get props => [];
}

class RespondToConnectionRequestEvent extends ConnectionEvent {
  final String connectionId;
  final String notificationsId;
  final bool accept;
  const RespondToConnectionRequestEvent({
    required this.connectionId,
    required this.notificationsId,
    required this.accept,
  });

  @override
  List<Object> get props => [connectionId, accept];
}

class LoadConnectionsEvent extends ConnectionEvent {}

part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {}

class NotificationsUpdatedEvent extends NotificationEvent {
  final List<NotificationModel> notifications;

  const NotificationsUpdatedEvent(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class MarkNotificationsAsReadEvent extends NotificationEvent {}

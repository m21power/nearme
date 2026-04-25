import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nearme/features/notification/domain/usecases/listen_notification_usecase.dart';
import 'package:nearme/features/notification/domain/usecases/mark_noti_as_read_usecase.dart';
import 'package:nearme/features/notification/domain/entities/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final MarkNotiAsReadUsecase markNotiAsReadUsecase;
  final ListenNotificationUsecase listenNotificationUsecase;

  StreamSubscription? _subscription;

  NotificationBloc({
    required this.markNotiAsReadUsecase,
    required this.listenNotificationUsecase,
  }) : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoad);
    on<NotificationsUpdatedEvent>(_onUpdated);
    on<MarkNotificationsAsReadEvent>(_onMarkRead);
  }

  // 👂 LISTEN
  Future<void> _onLoad(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    _subscription?.cancel();

    _subscription = listenNotificationUsecase().listen((notifications) {
      add(NotificationsUpdatedEvent(notifications));
    });
  }

  // 📥 UPDATE STATE
  void _onUpdated(
    NotificationsUpdatedEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationLoaded(event.notifications));
  }

  // ✅ MARK ALL READ
  Future<void> _onMarkRead(
    MarkNotificationsAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await markNotiAsReadUsecase();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

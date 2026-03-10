import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../data/repositories/notification_repository.dart';
import '../data/models/notification_model.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  StreamSubscription<List<NotificationModel>>? _notificationsSubscription;

  NotificationCubit(this._repository) : super(const NotificationState());

  Future<void> loadNotifications(String userId) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    final result = await _repository.getUserNotifications(userId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      )),
      (notifications) => emit(state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
        unreadCount: notifications.where((n) => !n.isRead).length,
      )),
    );
  }

  void listenToNotifications(String userId) {
    _notificationsSubscription?.cancel();
    _notificationsSubscription = _repository.getUserNotificationsStream(userId).listen(
      (notifications) {
        emit(state.copyWith(
          status: NotificationStatus.loaded,
          notifications: notifications,
          unreadCount: notifications.where((n) => !n.isRead).length,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          status: NotificationStatus.error,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    emit(state.copyWith(status: NotificationStatus.markingAsRead));

    final result = await _repository.markNotificationAsRead(userId, notificationId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();

        emit(state.copyWith(
          status: NotificationStatus.markedAsRead,
          notifications: updatedNotifications,
          unreadCount: updatedNotifications.where((n) => !n.isRead).length,
        ));
      },
    );
  }

  Future<void> markAllAsRead(String userId) async {
    emit(state.copyWith(status: NotificationStatus.markingAsRead));

    final result = await _repository.markAllNotificationsAsRead(userId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedNotifications = state.notifications
            .map((notification) => notification.copyWith(isRead: true))
            .toList();

        emit(state.copyWith(
          status: NotificationStatus.markedAsRead,
          notifications: updatedNotifications,
          unreadCount: 0,
        ));
      },
    );
  }

  Future<void> deleteNotification(String userId, String notificationId) async {
    emit(state.copyWith(status: NotificationStatus.deleting));

    final result = await _repository.deleteNotification(userId, notificationId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedNotifications = state.notifications
            .where((notification) => notification.id != notificationId)
            .toList();

        emit(state.copyWith(
          status: NotificationStatus.deleted,
          notifications: updatedNotifications,
          unreadCount: updatedNotifications.where((n) => !n.isRead).length,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
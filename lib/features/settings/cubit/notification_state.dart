import '../data/models/notification_model.dart';

enum NotificationStatus {
  initial,
  loading,
  loaded,
  error,
  markingAsRead,
  markedAsRead,
  deleting,
  deleted,
}

class NotificationState {
  final NotificationStatus status;
  final List<NotificationModel> notifications;
  final int unreadCount;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notifications,
    int? unreadCount,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'NotificationState(status: $status, notifications: ${notifications.length}, unreadCount: $unreadCount, errorMessage: $errorMessage)';
  }
}
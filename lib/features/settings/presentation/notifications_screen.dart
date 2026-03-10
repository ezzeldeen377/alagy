import 'package:alagy/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/common/cubit/app_user/app_user_cubit.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../data/models/notification_model.dart';
import 'package:alagy/core/helpers/extensions.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>(),
      child: const _NotificationsScreenBody(),
    );
  }
}

class _NotificationsScreenBody extends StatefulWidget {
  const _NotificationsScreenBody();

  @override
  State<_NotificationsScreenBody> createState() => _NotificationsScreenBodyState();
}

class _NotificationsScreenBodyState extends State<_NotificationsScreenBody> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AppUserCubit>().state.userId;
    if (userId != null) {
      context.read<NotificationCubit>().listenToNotifications(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifications),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    final userId = context.read<AppUserCubit>().state.userId;
                    if (userId != null) {
                      context.read<NotificationCubit>().markAllAsRead(userId);
                    }
                  },
                  child: Text(context.l10n.markAllRead),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          switch (state.status) {
            case NotificationStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case NotificationStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.w,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      context.l10n.errorLoadingNotifications,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.errorMessage ?? context.l10n.unknownErrorOccurred,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        final userId = context.read<AppUserCubit>().state.userId;
                        if (userId != null) {
                          context.read<NotificationCubit>().loadNotifications(userId);
                        }
                      },
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              );
            case NotificationStatus.loaded:
            case NotificationStatus.markedAsRead:
            case NotificationStatus.deleted:
              if (state.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64.w,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        context.l10n.noNotificationsYet,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.l10n.youllSeeNotificationsHere,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  final userId = context.read<AppUserCubit>().state.userId;
                  if (userId != null) {
                    await context.read<NotificationCubit>().loadNotifications(userId);
                  }
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return _NotificationCard(
                      notification: notification,
                      onTap: () {
                        final userId = context.read<AppUserCubit>().state.userId;
                        if (userId != null && !notification.isRead) {
                          context.read<NotificationCubit>().markAsRead(userId, notification.id);
                        }
                      },
                      onDelete: () {
                        final userId = context.read<AppUserCubit>().state.userId;
                        if (userId != null) {
                          context.read<NotificationCubit>().deleteNotification(userId, notification.id);
                        }
                      },
                    );
                  },
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: notification.isRead ? 1 : 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: notification.isRead ? Colors.grey[600] : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      timeago.format(notification.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              // Delete button
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.grey[400],
                  size: 20.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
        return Icons.calendar_today;
      case 'promotion':
        return Icons.local_offer;
      case 'reminder':
        return Icons.alarm;
      case 'system':
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
        return Colors.blue;
      case 'promotion':
        return Colors.green;
      case 'reminder':
        return Colors.orange;
      case 'system':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
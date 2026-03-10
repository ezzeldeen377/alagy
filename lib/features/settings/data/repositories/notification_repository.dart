import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getUserNotifications(String userId);
  Future<Either<Failure, void>> markNotificationAsRead(String userId, String notificationId);
  Future<Either<Failure, void>> markAllNotificationsAsRead(String userId);
  Future<Either<Failure, void>> deleteNotification(String userId, String notificationId);
  Future<Either<Failure, int>> getUnreadNotificationsCount(String userId);
  Stream<List<NotificationModel>> getUserNotificationsStream(String userId);
  Future<Either<Failure, String>> createNotification(String userId, NotificationModel notification);
}

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<NotificationModel>>> getUserNotifications(String userId) async {
    return await executeTryAndCatchForRepository(() async {
      return await _remoteDataSource.getUserNotifications(userId);
    });
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead(String userId, String notificationId) async {
    return await executeTryAndCatchForRepository(() async {
      return await _remoteDataSource.markNotificationAsRead(userId, notificationId);
    });
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsAsRead(String userId) async {
    return await executeTryAndCatchForRepository(() async {
      return await _remoteDataSource.markAllNotificationsAsRead(userId);
    });
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String userId, String notificationId) async {
    return await executeTryAndCatchForRepository(() async {
      return await _remoteDataSource.deleteNotification(userId, notificationId);
    });
  }

  @override
  Future<Either<Failure, int>> getUnreadNotificationsCount(String userId) async {
    return await executeTryAndCatchForRepository(() async {
      return await _remoteDataSource.getUnreadNotificationsCount(userId);
    });
  }

  @override
  Stream<List<NotificationModel>> getUserNotificationsStream(String userId) {
    return _remoteDataSource.getUserNotificationsStream(userId);
  }

  @override
  Future<Either<Failure, String>> createNotification(String userId, NotificationModel notification) async {
    return await executeTryAndCatchForRepository(() async {
      return await _remoteDataSource.createNotification(userId, notification);
    });
  }
}
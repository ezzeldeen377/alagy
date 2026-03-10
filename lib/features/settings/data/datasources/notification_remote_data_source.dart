import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/notification_model.dart';
import '../../../../core/constants/firebase_collections.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getUserNotifications(String userId);
  Future<void> markNotificationAsRead(String userId, String notificationId);
  Future<void> markAllNotificationsAsRead(String userId);
  Future<void> deleteNotification(String userId, String notificationId);
  Future<int> getUnreadNotificationsCount(String userId);
  Stream<List<NotificationModel>> getUserNotificationsStream(String userId);
  Future<String> createNotification(String userId, NotificationModel notification);
}

@Injectable(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _getUserNotificationsCollection(String userId) {
    return _firestore
        .collection(FirebaseCollections.usersCollection)
        .doc(userId)
        .collection('notifications');
  }

  @override
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      final querySnapshot = await _getUserNotificationsCollection(userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromMap({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Stream<List<NotificationModel>> getUserNotificationsStream(String userId) {
    return _getUserNotificationsCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromMap({
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                }))
            .toList());
  }

  @override
  Future<void> markNotificationAsRead(String userId, String notificationId) async {
    try {
      await _getUserNotificationsCollection(userId)
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final querySnapshot = await _getUserNotificationsCollection(userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  @override
  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _getUserNotificationsCollection(userId)
          .doc(notificationId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  @override
  Future<int> getUnreadNotificationsCount(String userId) async {
    try {
      final querySnapshot = await _getUserNotificationsCollection(userId)
          .where('isRead', isEqualTo: false)
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get unread notifications count: $e');
    }
  }

  @override
  Future<String> createNotification(String userId, NotificationModel notification) async {
    try {
      final docRef = await _getUserNotificationsCollection(userId)
          .add(notification.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }
}
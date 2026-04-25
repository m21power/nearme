import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/features/notification/domain/entities/notification_model.dart';
import 'package:nearme/features/notification/domain/repository/notification_repository.dart';

class NotificationRepoImpl implements NotificationRepository {
  final FirebaseFirestore firestore;
  NotificationRepoImpl({required this.firestore});
  @override
  Stream<List<NotificationModel>> listenNotifications() {
    final currentUserId = UserSession.instance.userId;
    return firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            print("**********************************************************");
            print("Notification doc data: $data");
            print(data['type']);
            return NotificationModel(
              id: doc.id,
              title: data['type'] ?? '',
              message: data['message'] ?? '',
              type: data['type'] ?? '',
              senderId: data['senderId'] ?? '',
              createdAt: data['createdAt'] is Timestamp
                  ? (data['createdAt'] as Timestamp).toDate()
                  : DateTime.parse(data['createdAt']),
              isRead: data['isRead'] ?? false,
            );
          }).toList();
        });
  }

  @override
  Future<void> markAsRead() async {
    final userId = UserSession.instance.userId;
    final batch = firestore.batch();
    final snapshot = await firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }
}

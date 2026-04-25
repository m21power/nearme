import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/connection_model.dart';
import 'package:nearme/features/home/domain/repository/connection_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/user_session.dart';
import '../../../core/network/network_info_impl.dart';

class ConnectionRepoImpl implements ConnectionRepository {
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firestore;
  final NetworkInfo networkInfo;
  ConnectionRepoImpl({
    required this.sharedPreferences,
    required this.firestore,
    required this.networkInfo,
  });
  @override
  Future<void> sendConnectionRequest(String userId) async {
    if (!await networkInfo.isConnected) {
      print('No internet connection. Cannot send connection request.');
    }

    try {
      final currentUserId = UserSession.instance.userId;
      final users = [currentUserId, userId].toList()..sort();
      final connectionId = users.join('_');
      // add connection at connections/{connectionId}
      await firestore.collection('connections').doc(connectionId).set({
        'users': users,
        'senderId': currentUserId,
        'receiverId': userId,
        'status': 'pending', // accepted, rejected
        'requestedAt': DateTime.now().toIso8601String(),
      });

      // now add to notifications/{notificationId}
      final notificationId = firestore.collection('notifications').doc().id;
      await firestore.collection('notifications').doc(notificationId).set({
        'receiverId': userId,
        'type': 'connection_request',
        'senderId': currentUserId,
        'message':
            'You have a new connection request from ${UserSession.instance.name}',
        'isRead': false,
        'responded': false,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error sending connection request: $e');
    }
  }

  @override
  Future<Either<Failure, List<ConnectionSuggestionModel>>>
  getConnectionSuggestions() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final currentUserId = UserSession.instance.userId;
      final querySnapshot = await firestore.collection('users').get();
      // for every user check in connections collection if there is a document with id currentUserId_userId or userId_currentUserId and status accepted or pending then ignore that user else add to suggestion list
      List<ConnectionSuggestionModel> suggestions = [];
      for (var doc in querySnapshot.docs) {
        final userId = doc.id;
        if (userId == currentUserId) continue;
        final connectionId1 = [currentUserId, userId].toList()..sort();
        final connectionId = connectionId1.join('_');
        final connectionDoc = await firestore
            .collection('connections')
            .doc(connectionId)
            .get();
        if (connectionDoc.exists) {
          continue;
        }
        suggestions.add(
          ConnectionSuggestionModel(
            userId: userId,
            name: doc['name'] ?? 'Unknown',
            dept: doc['dept'] ?? '---',
            year: doc['year'] ?? '---',
            profilePicUrl: doc['profileImage'] ?? '',
          ),
        );
      }

      return Right(suggestions);
    } catch (e) {
      print('Error fetching connection suggestions: $e');
      return Left(
        NetworkFailure(message: 'Error fetching connection suggestions'),
      );
    }
  }

  @override
  Stream<(List<ConnectionRequestModel>, int)>
  streamConnectionRequests() async* {
    if (!await networkInfo.isConnected) {
      yield ([], 0);
      return;
    }

    final currentUserId = UserSession.instance.userId;

    yield* firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: currentUserId)
        .where('type', isEqualTo: 'connection_request')
        .where('responded', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<ConnectionRequestModel> requests = [];
          int unseenCount = 0;

          for (var doc in snapshot.docs) {
            final senderId = doc['senderId'];
            final isRead = doc['isRead'] ?? false;

            if (!isRead) unseenCount++;

            final senderDoc = await firestore
                .collection('users')
                .doc(senderId)
                .get();
            final currentUserId = UserSession.instance.userId;
            final users = [currentUserId, senderId].toList()..sort();
            final connectionId = users.join('_');
            requests.add(
              ConnectionRequestModel(
                connectionId: connectionId,
                notificationId: doc.id,
                userId: senderId,
                name: senderDoc['name'] ?? 'Unknown',
                dept: senderDoc['dept'] ?? '---',
                year: senderDoc['year'] ?? '---',
                profilePicUrl: senderDoc['profileImage'] ?? '',
                requestedAt: doc['createdAt'],
              ),
            );
          }

          return (requests, unseenCount);
        });
  }

  @override
  Future<void> respondToConnectionRequest(
    String connectionId,
    String notificationsId,
    bool accept,
  ) async {
    if (!await networkInfo.isConnected) {
      // throw NetworkFailure(message: 'No internet connection');
      print("No internet connection. Cannot respond to connection request.");
      return;
    }

    try {
      final currentUserId = UserSession.instance.userId;
      final requestDoc = await firestore
          .collection('connections')
          .doc(connectionId)
          .get();
      if (!requestDoc.exists) {
        throw NetworkFailure(message: 'Connection request not found');
      }

      await firestore.collection('connections').doc(connectionId).update({
        'status': accept ? 'accepted' : 'rejected',
        'respondedAt': DateTime.now().toIso8601String(),
      });
      await firestore.collection('notifications').doc(notificationsId).update({
        'responded': true,
      });
      // now add notification to sender
      final senderId = requestDoc['senderId'];
      final notificationId = firestore.collection('notifications').doc().id;
      await firestore.collection('notifications').doc(notificationId).set({
        'receiverId': senderId,
        'type': accept ? 'connection_accepted' : 'connection_rejected',
        'senderId': currentUserId,
        'message': accept
            ? '${UserSession.instance.name} accepted your connection request'
            : '${UserSession.instance.name} rejected your connection request',
        'isRead': false,

        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error responding to connection request: $e');
      throw NetworkFailure(message: 'Error responding to connection request');
    }
  }

  @override
  Future<void> readConnectionRequest(String notificationId) {
    // mark the notification as read
    return firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  @override
  Future<Either<Failure, List<ConnectionModel>>> getConnections() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final currentUserId = UserSession.instance.userId;
      final querySnapshot = await firestore
          .collection('connections')
          .where('users', arrayContains: currentUserId)
          .where('status', isEqualTo: 'accepted')
          .get();

      List<ConnectionModel> connections = [];
      for (var doc in querySnapshot.docs) {
        final users = List<String>.from(doc['users']);
        final otherUserId = users.firstWhere(
          (id) => id != currentUserId,
          orElse: () => '',
        );
        if (otherUserId.isEmpty) continue;

        final userDoc = await firestore
            .collection('users')
            .doc(otherUserId)
            .get();
        connections.add(
          ConnectionModel(
            connectionId: doc.id,
            userId: otherUserId,
            name: userDoc['name'] ?? 'Unknown',
            dept: userDoc['dept'] ?? '---',
            year: userDoc['year'] ?? '---',
            profilePicUrl: userDoc['profileImage'] ?? '',
            connectedAt: doc['respondedAt'] ?? '',
          ),
        );
      }
      print(
        'Fetched ${connections.length} connections for user $currentUserId',
      );
      return Right(connections);
    } catch (e) {
      print('Error fetching connections: $e');
      return Left(NetworkFailure(message: 'Error fetching connections'));
    }
  }
}

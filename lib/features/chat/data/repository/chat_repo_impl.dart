import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/chat/domain/entities/chat_model.dart';
import 'package:nearme/features/chat/domain/repository/chat_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/network_info_impl.dart';

class ChatRepoImpl implements ChatRepository {
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firestore;
  final NetworkInfo networkInfo;
  final FirebaseDatabase firebaseDatabase;
  ChatRepoImpl({
    required this.sharedPreferences,
    required this.firestore,
    required this.networkInfo,
    required this.firebaseDatabase,
  });
  @override
  Stream<Either<Failure, List<ChatModel>>> getUserChats() async* {
    if (!await networkInfo.isConnected) {
      yield Left(NetworkFailure(message: 'No internet connection'));
      return;
    }

    try {
      final currentUserId = UserSession.instance.userId;

      final chatStream = firestore
          .collection('chats')
          .where('users', arrayContains: currentUserId)
          .snapshots();

      await for (final querySnapshot in chatStream) {
        Map<dynamic, bool> userOnlineStatus = {};

        final statusSnap = await firebaseDatabase.ref('status').get();
        if (statusSnap.exists) {
          final statusData = Map<dynamic, dynamic>.from(
            statusSnap.value as Map,
          );
          statusData.forEach((key, value) {
            userOnlineStatus[key] = value['state'] == 'online';
          });
        }

        final chats = querySnapshot.docs.map((doc) {
          final data = doc.data();

          return ChatModel(
            chatId: doc.id,
            users: List<String>.from(data['users'] ?? []),

            lastMessage: data['lastMessage'] ?? '',

            lastMessageAt: (data['lastMessageAt'] as Timestamp).toDate(),

            unreadCounts: Map<String, int>.from(
              (data['unreadCounts'] ?? {}).map(
                (k, v) => MapEntry(k, v is int ? v : 0),
              ),
            ),

            userNames: Map<String, String>.from(data['userNames'] ?? {}),

            userProfilePics: Map<String, String>.from(
              data['userProfilePics'] ?? {},
            ),

            userOnlineStatus: userOnlineStatus,
          );
        }).toList();

        yield Right(chats);
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Error fetching chats: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage(
    String chatId,
    String message,
    String otherUserId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // Simulate failure
    try {
      final currentUserId = UserSession.instance.userId;
      final chatRef = firestore.collection('chats').doc(chatId);
      final messageRef = chatRef.collection('messages').doc();

      await firestore.runTransaction((transaction) async {
        final chatSnap = await transaction.get(chatRef);

        List<String> users = [];

        /// CASE 1: CHAT DOESN'T EXIST
        if (!chatSnap.exists) {
          users = [currentUserId!, otherUserId];
          final otherUserDoc = await firestore
              .collection('users')
              .doc(otherUserId)
              .get();
          final otherUsername = otherUserDoc['name'] ?? 'Unknown';
          final otherUserProfilePic = otherUserDoc['profileImage'] ?? '';
          transaction.set(chatRef, {
            'users': users,
            'userProfilePics': {
              currentUserId: UserSession.instance.profileImage,
              otherUserId: otherUserProfilePic,
            },
            'userNames': {
              currentUserId: UserSession.instance.name,
              otherUserId: otherUsername,
            },
            'lastMessage': message,
            'lastMessageAt': FieldValue.serverTimestamp(),
            'createdAt': FieldValue.serverTimestamp(),
            'unreadCounts': {currentUserId: 0, otherUserId: 1},
          });
        } else {
          users = List<String>.from(chatSnap['users']);
        }
        print("users********************************************");
        print(users);

        /// CREATE MESSAGE
        transaction.set(messageRef, {
          'senderId': currentUserId,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'readBy': [currentUserId],
        });

        /// UPDATE UNREAD COUNTS LOCALLY
        final existingUnread = Map<String, dynamic>.from(
          chatSnap['unreadCounts'] ?? {},
        );

        for (var user in users) {
          if (user == currentUserId) {
            existingUnread[user] = 0; // reset current user's unread
          } else {
            final prev = existingUnread[user] ?? 0;
            existingUnread[user] = prev + 1; // increment others
          }
        }

        /// WRITE BACK THE UPDATED MAP
        if (chatSnap.exists) {
          transaction.update(chatRef, {
            'lastMessage': message,
            'lastMessageAt': FieldValue.serverTimestamp(),
            'unreadCounts': existingUnread,
          });
        }
      });
      final notificationId = firestore.collection('notifications').doc().id;

      await firestore.collection('notifications').doc(notificationId).set({
        'receiverId': otherUserId,
        'senderId': currentUserId,
        'type': 'chat_message',
        'chatId': chatId,
        'message': message,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return Right(
        MessageModel(
          messageId: messageRef.id,
          senderId: currentUserId!,
          message: message,
          timestamp: DateTime.now(),
          readBy: [currentUserId],
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Error sending message: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<MessageModel>>> getChatMessages(
    String chatId,
  ) async* {
    if (!await networkInfo.isConnected) {
      yield Left(NetworkFailure(message: 'No internet connection'));
      return;
    }

    try {
      final stream = firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();

      await for (final querySnapshot in stream) {
        final messages = querySnapshot.docs.map((doc) {
          final data = doc.data();

          return MessageModel(
            messageId: doc.id,
            senderId: data['senderId'] ?? '',
            message: data['message'] ?? '',
            timestamp: (data['timestamp'] as Timestamp).toDate(),
            readBy: List<String>.from(data['readBy'] ?? []),
          );
        }).toList();

        yield Right(messages);
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Error fetching messages: $e'));
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatId) async {
    final currentUserId = UserSession.instance.userId;
    final chatRef = firestore.collection('chats').doc(chatId);
    final messagesRef = chatRef.collection('messages');

    // 1️⃣ Get the chat document
    final chatSnap = await chatRef.get();
    if (!chatSnap.exists) return;

    // 2️⃣ Work with unreadCounts locally
    final unreadCounts = Map<String, dynamic>.from(
      chatSnap['unreadCounts'] ?? {},
    );
    if (unreadCounts[currentUserId!] == 0) return; // nothing to update

    unreadCounts[currentUserId!] = 0;

    final messagesSnap = await messagesRef.get();

    final batch = firestore.batch();

    batch.update(chatRef, {'unreadCounts': unreadCounts});

    // Update messages readBy locally
    for (var msgDoc in messagesSnap.docs) {
      final readBy = List<String>.from(msgDoc['readBy'] ?? []);
      if (!readBy.contains(currentUserId)) {
        final updatedReadBy = [...readBy, currentUserId];
        batch.update(msgDoc.reference, {'readBy': updatedReadBy});
      }
    }

    await batch.commit();
  }

  static void updateUserStatus() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref();

      final safeUserId = UserSession.instance.userId!
          .replaceAll('.', '')
          .replaceAll('#', '_')
          .replaceAll('\$', '_')
          .replaceAll('[', '_')
          .replaceAll(']', '_');

      final statusRef = dbRef.child('status').child(safeUserId);
      final connectedRef = dbRef.child('.info/connected');

      connectedRef.onValue.listen((event) async {
        final connected = event.snapshot.value as bool? ?? false;

        if (connected) {
          await statusRef.onDisconnect().set({
            'state': 'offline',
            'last_changed': ServerValue.timestamp,
          });

          await statusRef.set({
            'state': 'online',
            'last_changed': ServerValue.timestamp,
          });
        }
      });
    } catch (e, stack) {
      print("**********************************88");
      print("Error setting up user status listener: $e");
      print(stack);
      print("**********************************88");
    }
  }
}

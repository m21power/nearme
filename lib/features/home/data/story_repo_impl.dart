import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/repository/story_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/network_info_impl.dart';
import '../../profile/data/profile_repo_impl.dart';

class StoryRepoImpl implements StoryRepository {
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firestore;
  final NetworkInfo networkInfo;
  StoryRepoImpl({
    required this.sharedPreferences,
    required this.firestore,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, StoryModel>> createStory(
    String imagePath,
    String? caption,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final userId = UserSession.instance.userId;
      final userName = UserSession.instance.name ?? 'Unknown User';
      final userProfileUrl = UserSession.instance.profileImage ?? '';
      final imageUrl = await uploadImageToCloudinary(File(imagePath));
      if (imageUrl == null) {
        return Left(ServerFailure(message: "Failed to upload image"));
      }
      final storyDoc = firestore.collection('stories').doc();
      final storyId = storyDoc.id;

      final createdAt = DateTime.now();
      final expiresAt = createdAt.add(const Duration(hours: 24));

      final newStory = StoryModel(
        storyId: storyId,
        authorId: userId!,
        authorName: userName,
        authorUrl: userProfileUrl,
        mediaUrl: imageUrl,
        caption: caption ?? '',
        createdAt: createdAt.toIso8601String(),
        expiresAt: expiresAt.toIso8601String(),
        viewerCount: 0,
        likeCount: 0,
        isSeen: false,
        isLiked: false,
      );

      await storyDoc.set({
        'storyId': storyId,
        'authorId': userId,
        'authorName': userName,
        'authorUrl': userProfileUrl,
        'mediaUrl': imageUrl,
        'caption': caption ?? '',
        'createdAt': Timestamp.fromDate(createdAt),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'viewerCount': 0,
        'likeCount': 0,
      });

      return Right(newStory);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> deleteStory(String storyId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkFailure(message: 'No internet connection');
    }
    // delete the story document
    return firestore.collection('stories').doc(storyId).delete();
  }

  @override
  Future<Either<Failure, List<StoryModel>>> fetchStories() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final now = DateTime.now();
      final snapshot = await firestore
          .collection('stories')
          .where('expiresAt', isGreaterThan: Timestamp.fromDate(now))
          .orderBy('createdAt', descending: true)
          .get();
      // first check list of active stories i have seen from stories/{storyId}/views/{userId}
      final userId = UserSession.instance.userId;
      final seenStoryIds = <String>{};
      for (var doc in snapshot.docs) {
        final storyId = doc['storyId'];
        final viewDoc = await firestore
            .collection('stories')
            .doc(storyId)
            .collection('views')
            .doc(userId)
            .get();
        if (viewDoc.exists) {
          seenStoryIds.add(storyId);
        }
      }
      // check active story i liked from stories/{storyId}/views/{userId}
      final likedStoryIds = <String>{};
      for (var doc in snapshot.docs) {
        final storyId = doc['storyId'];
        final viewDoc = await firestore
            .collection('stories')
            .doc(storyId)
            .collection('views')
            .doc(userId)
            .get();
        if (viewDoc.exists && viewDoc.data()?['isLiked'] == true) {
          likedStoryIds.add(storyId);
        }
      }
      final stories = snapshot.docs.map((doc) {
        final data = doc.data();
        return StoryModel(
          storyId: data['storyId'],
          authorId: data['authorId'],
          authorName: data['authorName'],
          authorUrl: data['authorUrl'],
          mediaUrl: data['mediaUrl'],
          caption: data['caption'],
          createdAt: (data['createdAt'] as Timestamp)
              .toDate()
              .toIso8601String(),
          expiresAt: (data['expiresAt'] as Timestamp)
              .toDate()
              .toIso8601String(),
          viewerCount: data['viewerCount'] ?? 0,
          likeCount: data['likeCount'] ?? 0,
          isSeen: seenStoryIds.contains(data['storyId']) ? true : false,
          isLiked: likedStoryIds.contains(data['storyId']) ? true : false,
        );
      }).toList();

      return Right(stories);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> markStoryAsSeen(String storyId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkFailure(message: 'No internet connection');
    }
    try {
      // add seen at stories/{storyId}/views/{userId}
      final userId = UserSession.instance.userId;
      final viewRef = firestore
          .collection('stories')
          .doc(storyId)
          .collection('views')
          .doc(userId);
      await viewRef.set({'seenAt': Timestamp.now()});
      // then increment viewer count in stories/{storyId}
      final storyRef = firestore.collection('stories').doc(storyId);
      await storyRef.update({'viewerCount': FieldValue.increment(1)});
    } catch (e) {
      // throw ServerFailure(message: e.toString());
      print("Error marking story as seen: ${e.toString()}");
    }
  }

  @override
  Future<Either<Failure, List<ViewerModel>>> fetchViewer(String storyId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final snapshot = await firestore
          .collection('stories')
          .doc(storyId)
          .collection('views')
          .get();
      final viewers = <ViewerModel>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final viewerId = doc.id;
        final userDoc = await firestore.collection('users').doc(viewerId).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          viewers.add(
            ViewerModel(
              viewerId: userData['userId'] ?? viewerId,
              viewerName: userData['name'] ?? 'Unknown User',
              viewerProfileUrl: userData['profileImage'] ?? '',
              seenAt: (data['seenAt'] as Timestamp).toDate().toIso8601String(),
              isLiked: data['isLiked'] ?? false,
            ),
          );
        }
      }
      return Right(viewers);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> likeStory(String storyId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkFailure(message: 'No internet connection');
    }
    try {
      final userId = UserSession.instance.userId;
      final viewRef = firestore
          .collection('stories')
          .doc(storyId)
          .collection('views')
          .doc(userId);
      // check if user has already liked the story
      final viewDoc = await viewRef.get();
      if (viewDoc.exists && viewDoc.data()?['isLiked'] == true) {
        // user has already liked the story, so we will unlike it
        await viewRef.set({'isLiked': false}, SetOptions(merge: true));
        final storyRef = firestore.collection('stories').doc(storyId);
        await storyRef.update({'likeCount': FieldValue.increment(-1)});
        return;
      }
      await viewRef.set({'isLiked': true}, SetOptions(merge: true));
      final storyRef = firestore.collection('stories').doc(storyId);
      await storyRef.update({'likeCount': FieldValue.increment(1)});
    } catch (e) {
      print("Error liking story: ${e.toString()}");
    }
  }
}
